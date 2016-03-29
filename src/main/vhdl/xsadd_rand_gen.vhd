-----------------------------------------------------------------------------------
--!     @file    xsadd_rand_gen.vhd
--!     @brief   Pseudo Random Number Generator (XORSHIFT-ADD).
--!     @version 1.0.0
--!     @date    2016/3/29
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
library XSADD;
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
    function  INIT_STATUS(PARAM:  PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE) return STATUS_VECTOR
    is
        variable  next_status  :  PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE;
        variable  status       :  STATUS_VECTOR(L-1 downto 0);
    begin
        next_status := PARAM;
        for i in status'low to status'high loop
            NEXT_PSEUDO_RANDOM_NUMBER_GENERATOR(next_status);
            status(i) := next_status;
        end loop;
        return status;
    end function;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    function  INIT_STATUS(DATA :std_logic_vector) return STATUS_VECTOR is
        variable param : PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE;
    begin
        for i in 0 to 3 loop
            param.status(i) := unsigned(DATA(32*(i+1)-1 downto 32*i));
        end loop;
        return INIT_STATUS(param);
    end function;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    function  INIT_STATUS(SEED :integer) return STATUS_VECTOR is
    begin
        return INIT_STATUS(NEW_PSEUDO_RANDOM_NUMBER_GENERATOR(TO_SEED_TYPE(SEED)));
    end function;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    signal    curr_status      :  STATUS_VECTOR(L-1 downto 0);
    signal    random_number    :  RANDOM_NUMBER_VECTOR(L-1 downto 0);
    signal    random_valid     :  boolean;
    signal    running          :  boolean;
    signal    status_valid     :  boolean;
    signal    status_ready     :  boolean;
begin
    -------------------------------------------------------------------------------
    -- running       :
    -------------------------------------------------------------------------------
    process(CLK, RST) begin
        if (RST = '1') then
            running <= FALSE;
        elsif (CLK'event and CLK = '1') then
            running <= TRUE;
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
            curr_status <= INIT_STATUS(SEED);
        elsif (CLK'event and CLK = '1') then
            if (TBL_INIT = '1') then
                curr_status  <= INIT_STATUS(TBL_WDATA);
            elsif (status_valid = TRUE and status_ready = TRUE) then
                next_status  := curr_status(curr_status'high);
                for i in curr_status'low to curr_status'high loop
                    NEXT_PSEUDO_RANDOM_NUMBER_GENERATOR(next_status);
                    curr_status(i) <= next_status;
                end loop;
            end if;
        end if;
    end process;
    status_valid <= (running = TRUE and TBL_INIT = '0' and RND_RUN = '1');
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
                for i in curr_status'range loop
                    random_number(i) <= GENERATE_TEMPER(curr_status(i));
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
end RTL;