-----------------------------------------------------------------------------------
--!     @file    xsadd_rand_gen.vhd
--!     @brief   Pseudo Random Number Generator (XORSHIFT-ADD).
--!     @version 1.0.1
--!     @date    2016/3/30
--!     @author  Ichiro Kawazome <ichiro_k@ca2.so-net.ne.jp>
-----------------------------------------------------------------------------------
--
--      Copyright (C) 2016 Ichiro Kawazome
--      All rights reserved.
--
--      Redistribution and use in source and binary forms, with or without
--      modification, are permitted provided that the following conditions
--      are met:
--
--        1. Redistributions of source code must retain the above copyright
--           notice, this list of conditions and the following disclaimer.
--
--        2. Redistributions in binary form must reproduce the above copyright
--           notice, this list of conditions and the following disclaimer in
--           the documentation and/or other materials provided with the
--           distribution.
--
--      THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
--      "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
--      LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
--      A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT
--      OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
--      SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
--      LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
--      DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
--      THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
--      (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
--      OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
--
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
entity  XSADD_RAND_GEN is
    generic (
        L           :     integer   := 1;
        SEED        :     integer   := 1234
    );
    port (
        CLK         : in  std_logic;
        RST         : in  std_logic;
        TBL_INIT    : in  std_logic := '0';
        TBL_WDATA   : in  std_logic_vector(127 downto 0) := (others => '0');
        TBL_RDATA   : out std_logic_vector(127 downto 0);
        RND_RUN     : in  std_logic := '1';
        RND_VAL     : out std_logic;
        RND_NUM     : out std_logic_vector(L*32-1 downto 0);
        RND_RDY     : in  std_logic := '1'
    );
end     XSADD_RAND_GEN;
-----------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
library XSADD;
use     XSADD.XSADD.all;
architecture RTL of XSADD_RAND_GEN is
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    type      STATUS_VECTOR    is array(integer range <>) of PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    constant  RESET_STATUSES   :  STATUS_VECTOR(L-1 downto 0)
                               := (others => NEW_PSEUDO_RANDOM_NUMBER_GENERATOR(TO_SEED_TYPE(SEED)));
    signal    curr_statuses    :  STATUS_VECTOR(L-1 downto 0);
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    signal    random_number    :  RANDOM_NUMBER_VECTOR(L-1 downto 0);
    signal    random_valid     :  boolean;
    signal    initial_next     :  boolean;
    signal    status_valid     :  boolean;
    signal    status_ready     :  boolean;
begin
    -------------------------------------------------------------------------------
    -- initial_next  :
    -------------------------------------------------------------------------------
    process(CLK, RST) begin
        if (RST = '1') then
            initial_next <= TRUE;
        elsif (CLK'event and CLK = '1') then
            initial_next <= (TBL_INIT = '1');
        end if;
    end process;
    -------------------------------------------------------------------------------
    -- curr_status   :
    -- status_valid  :
    -------------------------------------------------------------------------------
    process(CLK, RST)
        variable next_status   :  PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE;
    begin
        if (RST = '1') then
            curr_statuses <= RESET_STATUSES;
        elsif (CLK'event and CLK = '1') then
            if (TBL_INIT = '1') then
                for i in 0 to 3 loop
                    next_status.status(i) := unsigned(TBL_WDATA(32*(i+1)-1 downto 32*i));
                end loop;
                curr_statuses(curr_statuses'high) <= next_status;
            elsif (initial_next = TRUE) or
                  (status_valid = TRUE and status_ready = TRUE) then
                next_status := curr_statuses(curr_statuses'high);
                for i in curr_statuses'low to curr_statuses'high loop
                    NEXT_PSEUDO_RANDOM_NUMBER_GENERATOR(next_status);
                    curr_statuses(i) <= next_status;
                end loop;
            end if;
        end if;
    end process;
    status_valid <= (initial_next = FALSE and TBL_INIT = '0' and RND_RUN = '1');
    -------------------------------------------------------------------------------
    -- random_number :
    -- random_valid  :
    -- status_ready  :
    -------------------------------------------------------------------------------
    process(CLK, RST) begin
        if (RST = '1') then
            random_valid  <= FALSE;
            random_number <= (others => (others => '0'));
        elsif (CLK'event and CLK = '1') then
            random_valid  <= status_valid;
            if (status_valid = TRUE and status_ready = TRUE) then
                for i in curr_statuses'range loop
                    random_number(i) <= GENERATE_TEMPER(curr_statuses(i));
                end loop;
            end if;
        end if;
    end process;
    status_ready <= ((random_valid = FALSE) or
                     (random_valid = TRUE  and RND_RDY = '1'));
    -------------------------------------------------------------------------------
    -- RND_VAL       :
    -- RND_NUM       :
    -------------------------------------------------------------------------------
    RND_VAL <= '1' when (random_valid = TRUE) else '0';
    RND_NUM_GEN: for i in 0 to L-1 generate
        RND_NUM(32*(i+1)-1 downto 32*i) <= std_logic_vector(random_number(i));
    end generate;
    -------------------------------------------------------------------------------
    -- TBL_RDATA     :
    -------------------------------------------------------------------------------
    TBL_RDATA_GEN: for i in 0 to 3 generate
        TBL_RDATA(32*(i+1)-1 downto 32*i) <= std_logic_vector(curr_statuses(L-1).status(i));
    end generate;
end RTL;
