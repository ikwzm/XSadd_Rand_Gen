-----------------------------------------------------------------------------------
--!     @file    test_bench.vhd
--!     @brief   Test Bench for xsadd_gen
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
use     ieee.numeric_std.all;
use     std.textio.all;
library XSADD;
use     XSADD.XSADD.all;
entity  TEST_BENCH is
end     TEST_BENCH;
architecture MODEL of TEST_BENCH is
    constant  PERIOD    : time := 10 ns;
    constant  DELAY     : time := 1 ns;
    constant  SEED      : integer := 1234;
    constant  L         : integer := 6;
    signal    CLK       : std_logic;
    signal    RST       : std_logic;
    signal    TBL_INIT  : std_logic;
    signal    TBL_WDATA : std_logic_vector(127 downto 0);
    signal    TBL_RDATA : std_logic_vector(127 downto 0);
    signal    RND_NUM   : std_logic_vector(L*32-1 downto 0);
    signal    RND_RUN   : std_logic;
    signal    RND_VAL   : std_logic;
    signal    RND_RDY   : std_logic;
begin
    U: entity XSADD.XSADD_RAND_GEN
        generic map (
            L           => L,
            SEED        => SEED
        )
        port map(
            CLK         => CLK      ,
            RST         => RST      ,
            TBL_INIT    => TBL_INIT ,
            TBL_WDATA   => TBL_WDATA,
            TBL_RDATA   => TBL_RDATA,
            RND_RUN     => RND_RUN  ,
            RND_VAL     => RND_VAL  ,
            RND_NUM     => RND_NUM  ,
            RND_RDY     => RND_RDY
        );
    
    process begin
        CLK <= '1'; wait for PERIOD/2;
        CLK <= '0'; wait for PERIOD/2;
    end process;

    process
        ---------------------------------------------------------------------------
        -- unsigned to hex string.
        ---------------------------------------------------------------------------
        function TO_HEX_STRING(arg:unsigned;len:integer;space:character) return STRING is
            variable str   : STRING(len downto 1);
            variable value : unsigned(arg'length-1 downto 0);
        begin
            value  := arg;
            for i in str'right to str'left loop
                if (value > 0) then
                    case (to_integer(value mod 16)) is
                        when  0     => str(i) := '0';
                        when  1     => str(i) := '1';
                        when  2     => str(i) := '2';
                        when  3     => str(i) := '3';
                        when  4     => str(i) := '4';
                        when  5     => str(i) := '5';
                        when  6     => str(i) := '6';
                        when  7     => str(i) := '7';
                        when  8     => str(i) := '8';
                        when  9     => str(i) := '9';
                        when 10     => str(i) := 'a';
                        when 11     => str(i) := 'b';
                        when 12     => str(i) := 'c';
                        when 13     => str(i) := 'd';
                        when 14     => str(i) := 'e';
                        when 15     => str(i) := 'f';
                        when others => str(i) := 'X';
                    end case;
                else
                    if (i = str'right) then
                        str(i) := '0';
                    else
                        str(i) := space;
                    end if;
                end if;
                value := value / 16;
            end loop;
            return str;
        end function;
        ---------------------------------------------------------------------------
        -- unsigned to decimal string.
        ---------------------------------------------------------------------------
        function TO_DEC_STRING(arg:unsigned;len:integer;space:character) return STRING is
            variable str   : STRING(len downto 1);
            variable value : unsigned(arg'length-1 downto 0);
        begin
            value  := arg;
            for i in str'right to str'left loop
                if (value > 0) then
                    case (to_integer(value mod 10)) is
                        when 0      => str(i) := '0';
                        when 1      => str(i) := '1';
                        when 2      => str(i) := '2';
                        when 3      => str(i) := '3';
                        when 4      => str(i) := '4';
                        when 5      => str(i) := '5';
                        when 6      => str(i) := '6';
                        when 7      => str(i) := '7';
                        when 8      => str(i) := '8';
                        when 9      => str(i) := '9';
                        when others => str(i) := 'X';
                    end case;
                else
                    if (i = str'right) then
                        str(i) := '0';
                    else
                        str(i) := space;
                    end if;
                end if;
                value := value / 10;
            end loop;
            return str;
        end function;
        ---------------------------------------------------------------------------
        -- unsigned to decimal string
        ---------------------------------------------------------------------------
        function TO_DEC_STRING(arg:unsigned;len:integer) return STRING is
        begin
            return  TO_DEC_STRING(arg,len,' ');
        end function;
        ---------------------------------------------------------------------------
        -- unsigned to decimal string
        ---------------------------------------------------------------------------
        function TO_HEX_STRING(arg:unsigned;len:integer) return STRING is
        begin
            return  TO_HEX_STRING(arg,len,'0');
        end function;
        ---------------------------------------------------------------------------
        -- real number to decimal string.
        ---------------------------------------------------------------------------
        function TO_DEC_STRING(arg:real;len1,len2:integer) return STRING is
            variable str   : STRING(len2-1 downto 0);
            variable i,n,p : integer;
        begin
            i := integer(arg);
            if    real(i) = arg then
                n := i;
            elsif i > 0 and real(i) > arg then
                n := i-1;  
            elsif i < 0 and real(i) < arg then
                n := i+1;
            else  
                n := i;
            end if;
            p := integer((arg-real(n))*(10.0**len2));
            return  TO_DEC_STRING(to_unsigned(n,len1-len2-1),len1-len2-1,' ') & "." & 
                    TO_DEC_STRING(to_unsigned(p,32),len2,'0');
        end function;
        ---------------------------------------------------------------------------
        -- Pseudo Random Number Generator Initalize Parameters.
        ---------------------------------------------------------------------------
        constant init_key  : SEED_VECTOR(0 to 3) := (0 => TO_SEED_TYPE(16#0A#),
                                                     1 => TO_SEED_TYPE(16#0B#),
                                                     2 => TO_SEED_TYPE(16#0C#),
                                                     3 => TO_SEED_TYPE(16#0D#));
        variable param     : PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE :=
                             NEW_PSEUDO_RANDOM_NUMBER_GENERATOR(TO_SEED_TYPE(SEED));
        ---------------------------------------------------------------------------
        -- for display
        ---------------------------------------------------------------------------
        constant TAG       : STRING(1 to 1) := " ";
        constant SPACE     : STRING(1 to 1) := " ";
        variable text_line : LINE;
        ---------------------------------------------------------------------------
        -- 
        ---------------------------------------------------------------------------
        procedure WAIT_CLK(CNT:integer) is
        begin
            for i in 1 to CNT loop 
                wait until (CLK'event and CLK = '1'); 
            end loop;
            wait for DELAY;
        end WAIT_CLK;
        ---------------------------------------------------------------------------
        -- 
        ---------------------------------------------------------------------------
        variable rand_num  : unsigned(31 downto 0);
        variable sample_num: integer;
        constant sample_max: integer := 40;
        ---------------------------------------------------------------------------
        -- 
        ---------------------------------------------------------------------------
        constant WAIT_MAX  : RANDOM_NUMBER_TYPE := "10000000000000000000000000000000";
        constant WAIT_MIN  : RANDOM_NUMBER_TYPE := "00000000000000000000000000001000";
        variable wait_num  : RANDOM_NUMBER_TYPE;
        variable wait_next : RANDOM_NUMBER_TYPE;
        type     EXP_PAT1_VEC is array(integer range <>) of STRING(1 to 10);
        type     EXP_PAT2_VEC is array(integer range <>) of STRING(1 to  8);
        constant exp_pat_1 : EXP_PAT1_VEC(0 to sample_max-1) := (
            "1823491521", "1658333335", "1467485721", "  45623648", 
            "3336175492", "2561136018", " 181953608", " 768231638", 
            "3747468990", " 633754442", "1317015417", "2329323117", 
            " 688642499", "1053686614", "1029905208", "3711673957", 
            "2701869769", " 695757698", "3819984643", "1221024953", 
            " 110368470", "2794248395", "2962485574", "3345205107", 
            " 592707216", "1730979969", "2620763022", " 670475981", 
            "1891156367", "3882783688", "1913420887", "1592951790", 
            "2760991171", "1168232321", "1650237229", "2083267498", 
            "2743918768", "3876980974", "2059187728", "3236392632");
        constant exp_pat_2 : EXP_PAT2_VEC(0 to sample_max-1) := (
            "138a38f9"  , "b396fa84"  , "a55a2ee8"  , "24b7ed06"  , 
            "f0bae2fe"  , "d8ace1a7"  , "d4b09a3f"  , "d7fcf441"  , 
            "fc55ee1b"  , "5b4ab585"  , "d4bf254b"  , "5b0f77ba"  , 
            "31161b97"  , "b21ccc3b"  , "ab418bfb"  , "4cc8476a"  , 
            "06a1a28f"  , "cb1f50c6"  , "f0ba2ed3"  , "7907f372"  , 
            "3256d76c"  , "d843e864"  , "d63a60b7"  , "eff88358"  , 
            "ddc3b083"  , "b5734b65"  , "f08d644d"  , "e5f6c809"  , 
            "95bf2ae3"  , "e5867758"  , "f260d462"  , "39d244dc"  , 
            "b9fbb8d7"  , "63e8f3d9"  , "b34ea936"  , "8fe4ee75"  , 
            "8803c8f1"  , "d74e420e"  , "a5c14d22"  , "20be253f"  );
    begin
        RST        <= '1';
        TBL_INIT   <= '0';
        TBL_WDATA  <= (others => '0');
        RND_RUN    <= '0';
        RND_RDY    <= '0';
        WAIT_CLK(10);
        RST        <= '0';
        WAIT_CLK(10);
        RND_RUN    <= '1';
        RND_RDY    <= '1';
        WRITE(text_line, "xsadd_init(" & TO_DEC_STRING(to_unsigned(SEED,32),4) & ")");
        WRITELINE(OUTPUT, text_line);
        WRITE(text_line, "32-bit unsigned integers r, where 0 <= r < 2^32" & SPACE);
        WRITELINE(OUTPUT, text_line);
        WAIT_CLK(1);
        sample_num := 0;
        wait_next  := WAIT_MAX;
        wait_num   := WAIT_MAX;
        LOOP1: loop
            wait until (CLK'event and CLK = '1');
            if (RND_VAL = '1' and RND_RDY = '1') then
                for n in 0 to L-1 loop
                    rand_num := TO_01(unsigned(RND_NUM(32*(n+1)-1 downto 32*n)));
                    WRITE(text_line, TO_DEC_STRING(rand_num,10) & SPACE);
                    if (sample_num mod 4 = 3) then
                        WRITELINE(OUTPUT, text_line);
                    end if;
                    assert (TO_DEC_STRING(rand_num,10) = exp_pat_1(sample_num))
                        report "Mismatch" severity ERROR;
                    sample_num := sample_num + 1;
                    if (sample_num >= sample_max) then
                        exit LOOP1;
                    end if;
                end loop;
                wait_num  := WAIT_MAX;
                wait_next := to_01(unsigned(RND_NUM(31 downto 0)));
                RND_RDY   <= '0' after DELAY;
            end if;
            if (wait_next >= wait_num or wait_num <= WAIT_MIN) then
                RND_RDY   <= '1' after DELAY;
            else
                wait_num  := wait_num / 2;
            end if;
        end loop;
        WRITELINE(OUTPUT, text_line);
        RND_RUN  <= '0' after DELAY;
        RND_RDY  <= '0' after DELAY;

        INIT_PSEUDO_RANDOM_NUMBER_GENERATOR(param,TO_SEED_TYPE(SEED));
     -- WRITE(text_line, TO_HEX_STRING(unsigned(TO_01(param.status(0))),10) & SPACE);
     -- WRITE(text_line, TO_HEX_STRING(unsigned(TO_01(param.status(1))),10) & SPACE);
     -- WRITE(text_line, TO_HEX_STRING(unsigned(TO_01(param.status(2))),10) & SPACE);
     -- WRITE(text_line, TO_HEX_STRING(unsigned(TO_01(param.status(3))),10));
     -- WRITELINE(OUTPUT, text_line);
        WRITE(text_line, "xsadd_init(" & TO_DEC_STRING(to_unsigned(SEED,32),4) & ")");
        WRITELINE(OUTPUT, text_line);
        WRITE(text_line, "32-bit unsigned integers r, where 0 <= r < 2^32" & SPACE);
        WRITELINE(OUTPUT, text_line);
        TBL_INIT   <= '1';
        TBL_WDATA( 31 downto  0) <= std_logic_vector(param.status(0));
        TBL_WDATA( 63 downto 32) <= std_logic_vector(param.status(1));
        TBL_WDATA( 95 downto 64) <= std_logic_vector(param.status(2));
        TBL_WDATA(127 downto 96) <= std_logic_vector(param.status(3));
        WAIT_CLK(1);
        TBL_INIT   <= '0';
        RND_RUN    <= '1';
        RND_RDY    <= '1';
        WAIT_CLK(1);
        sample_num := 0;
        wait_next  := WAIT_MAX;
        wait_num   := WAIT_MAX;
        LOOP2: loop
            wait until (CLK'event and CLK = '1');
            if (RND_VAL = '1' and RND_RDY = '1') then
                for n in 0 to L-1 loop
                    rand_num := TO_01(unsigned(RND_NUM(32*(n+1)-1 downto 32*n)));
                    WRITE(text_line, TO_DEC_STRING(rand_num,10) & SPACE);
                    if (sample_num mod 4 = 3) then
                        WRITELINE(OUTPUT, text_line);
                    end if;
                    assert (TO_DEC_STRING(rand_num,10) = exp_pat_1(sample_num))
                        report "Mismatch" severity ERROR;
                    sample_num := sample_num + 1;
                    if (sample_num >= sample_max) then
                        exit LOOP2;
                    end if;
                end loop;
                wait_num  := WAIT_MAX;
                wait_next := to_01(unsigned(RND_NUM(31 downto 0)));
                RND_RDY   <= '0' after DELAY;
            end if;
            if (wait_next >= wait_num or wait_num <= WAIT_MIN) then
                RND_RDY   <= '1' after DELAY;
            else
                wait_num  := wait_num / 2;
            end if;
        end loop;
        WRITELINE(OUTPUT, text_line);
        RND_RUN  <= '0' after DELAY;
        RND_RDY  <= '0' after DELAY;

        INIT_PSEUDO_RANDOM_NUMBER_GENERATOR(param,init_key);
     -- WRITE(text_line, "0x" & TO_HEX_STRING(unsigned(param.status(0)),8) & SPACE);
     -- WRITE(text_line, "0x" & TO_HEX_STRING(unsigned(param.status(1)),8) & SPACE);
     -- WRITE(text_line, "0x" & TO_HEX_STRING(unsigned(param.status(2)),8) & SPACE);
     -- WRITE(text_line, "0x" & TO_HEX_STRING(unsigned(param.status(3)),8) & SPACE);
     -- WRITELINE(OUTPUT, text_line);
        WRITE(text_line, "xsadd_init([0x" & TO_HEX_STRING(unsigned(init_key(0)),2) &
                                   ", 0x" & TO_HEX_STRING(unsigned(init_key(1)),2) &
                                   ", 0x" & TO_HEX_STRING(unsigned(init_key(2)),2) &
                                   ", 0x" & TO_HEX_STRING(unsigned(init_key(3)),2) & "])");
        WRITELINE(OUTPUT, text_line);
        WRITE(text_line, "32-bit unsigned integers r, where 0 <= r < 2^32" & SPACE);
        WRITELINE(OUTPUT, text_line);
        TBL_INIT   <= '1';
        TBL_WDATA( 31 downto  0) <= std_logic_vector(param.status(0));
        TBL_WDATA( 63 downto 32) <= std_logic_vector(param.status(1));
        TBL_WDATA( 95 downto 64) <= std_logic_vector(param.status(2));
        TBL_WDATA(127 downto 96) <= std_logic_vector(param.status(3));
        WAIT_CLK(1);
        TBL_INIT   <= '0';
        RND_RUN    <= '1';
        WAIT_CLK(1);
        RND_RDY    <= '0';
        sample_num := 0;
        wait_next  := WAIT_MAX+1;
        wait_num   := WAIT_MAX;
        LOOP3: loop
            wait until (CLK'event and CLK = '1');
            if (RND_VAL = '1' and RND_RDY = '1') then
                for n in 0 to L-1 loop
                    rand_num := TO_01(unsigned(RND_NUM(32*(n+1)-1 downto 32*n)));
                    WRITE(text_line, TO_HEX_STRING(rand_num,8) & SPACE);
                    if (sample_num mod 4 = 3) then
                        WRITELINE(OUTPUT, text_line);
                    end if;
                    assert (TO_HEX_STRING(rand_num,8) = exp_pat_2(sample_num))
                        report "Mismatch" severity ERROR;
                    sample_num := sample_num + 1;
                    if (sample_num >= sample_max) then
                        exit LOOP3;
                    end if;
                end loop;
                wait_num  := WAIT_MAX;
                wait_next := to_01(unsigned(RND_NUM(31 downto 0)));
                RND_RDY   <= '0' after DELAY;
            end if;
            if (wait_next >= wait_num or wait_num <= WAIT_MIN) then
                RND_RDY   <= '1' after DELAY;
            else
                wait_num  := wait_num / 2;
            end if;
        end loop;
        WRITELINE(OUTPUT, text_line);
        RND_RUN  <= '0' after DELAY;
        RND_RDY  <= '0' after DELAY;

        assert(false) report TAG & " Run complete..." severity FAILURE;
        wait;
    end process;
end MODEL;
