-----------------------------------------------------------------------------------
--!     @file    xsadd.vhd
--!     @brief   Pseudo Random Number Generator Package(XORSHIFT-ADD).
--!     @version 1.0.0
--!     @date    2016/3/25
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
-----------------------------------------------------------------------------------
--! @brief   Pseudo Random Number Generator Package(XORSHIFT-ADD).
-----------------------------------------------------------------------------------
package XSADD is
    -------------------------------------------------------------------------------
    --! @brief Type of Random Number.
    -------------------------------------------------------------------------------
    subtype  RANDOM_NUMBER_TYPE   is unsigned(31 downto 0);
    -------------------------------------------------------------------------------
    --! @brief Vector of Random Number.
    -------------------------------------------------------------------------------
    type     RANDOM_NUMBER_VECTOR is array(integer range <>) of RANDOM_NUMBER_TYPE;
    -------------------------------------------------------------------------------
    --! @brief Convert Integer to RANDOM_NUMBER_TYPE
    --! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    --! @param    arg       Integer.
    --! @return             Generated random number.
    -------------------------------------------------------------------------------
    function TO_RANDOM_NUMBER_TYPE(arg:integer) return RANDOM_NUMBER_TYPE;
    -------------------------------------------------------------------------------
    --! @brief Type of Seed Number for Pseudo Random Number Generator.
    -------------------------------------------------------------------------------
    subtype  SEED_TYPE            is unsigned(31 downto 0);
    -------------------------------------------------------------------------------
    --! @brief Vector of Seed Number for Pseudo Random Number Generator.
    -------------------------------------------------------------------------------
    type     SEED_VECTOR          is array(integer range <>) of SEED_TYPE;
    -------------------------------------------------------------------------------
    --! @brief Convert Integer to SEED_TYPE
    --! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    --! @param    arg       Integer.
    --! @return             Generated seed number.
    -------------------------------------------------------------------------------
    function TO_SEED_TYPE(arg:integer) return SEED_TYPE;
    -------------------------------------------------------------------------------
    --! @brief Type of Record for Pseudo Random Number Generator.
    -------------------------------------------------------------------------------
    type     PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE is record
        status  : RANDOM_NUMBER_VECTOR(0 to 3);
    end record;    
    -------------------------------------------------------------------------------
    --! @brief Generate instance for Pseudo Random Number Generator.
    --! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    --! @param    seed      Seed Number for Pseudo Random Number Generator.
    --! @return             Pseudo Random Number Generator.
    -------------------------------------------------------------------------------
    function  NEW_PSEUDO_RANDOM_NUMBER_GENERATOR(
                 seed      :       SEED_TYPE
    )            return            PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE;
    -------------------------------------------------------------------------------
    --! @brief Generate instance for Pseudo Random Number Generator.
    --! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    --! @param    seed      Seed Number Vector for Pseudo Random Number Generator.
    --! @return             Pseudo Random Number Generator.
    -------------------------------------------------------------------------------
    function  NEW_PSEUDO_RANDOM_NUMBER_GENERATOR(
                 seed      :       SEED_VECTOR
    )            return            PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE;
    -------------------------------------------------------------------------------
    --! @brief Initialize Pseudo Random Number Generator.
    --! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    --! @param    generator Pseudo Random Number Generator.
    --! @param    mat1      Parameter for Pseudo Random Number Generator.
    --! @param    mat2      Parameter for Pseudo Random Number Generator.
    --! @param    tmat      Parameter for Pseudo Random Number Generator.
    --! @param    seed      Seed Number for Pseudo Random Number Generator.
    -------------------------------------------------------------------------------
    procedure INIT_PSEUDO_RANDOM_NUMBER_GENERATOR(
        variable generator : inout PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE;
                 seed      : in    SEED_TYPE
    );
    -------------------------------------------------------------------------------
    --! @brief Initialize Pseudo Random Number Generator.
    --! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    --! @param    generator Pseudo Random Number Generator.
    --! @param    seed      Seed Number Vector for Pseudo Random Number Generator.
    -------------------------------------------------------------------------------
    procedure INIT_PSEUDO_RANDOM_NUMBER_GENERATOR(
        variable generator : inout PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE;
                 seed      : in    SEED_VECTOR
    );
    -------------------------------------------------------------------------------
    --! @brief This function changes internal state of tinymt32.
    --! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    --! * Users should not call this function directly.
    --! @param    generator Pseudo Random Number Generator.
    -------------------------------------------------------------------------------
    procedure NEXT_PSEUDO_RANDOM_NUMBER_GENERATOR(
        variable generator : inout PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE
    );
    -------------------------------------------------------------------------------
    --! @brief This function outputs 32-bit unsigned integer from internal state.
    --! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    --! * Users should not call this function directly.
    --! @param    generator Pseudo Random Number Generator.
    --! @return             Generated temper number.
    -------------------------------------------------------------------------------
    function  GENERATE_TEMPER(
                 generator : PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE
    )            return      RANDOM_NUMBER_TYPE;
    -------------------------------------------------------------------------------
    --! @brief Generates a random number
    --! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    --! @param    generator Pseudo Random Number Generator.
    --! @param    number    Generated random number.
    -------------------------------------------------------------------------------
    procedure GENERATE_RANDOM_NUMBER(
        variable generator : inout PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE;
        variable number    : out   RANDOM_NUMBER_TYPE
    );
    -------------------------------------------------------------------------------
    --! @brief Generates a random number on (std_logic_vector).
    --! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    --! @param    generator Pseudo Random Number Generator.
    --! @param    number    Generated random number.
    -------------------------------------------------------------------------------
    procedure GENERATE_RANDOM_STD_LOGIC_VECTOR(
        variable generator : inout PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE;
        variable number    : out   std_logic_vector
    );
    -------------------------------------------------------------------------------
    --! @brief Generates a random number on [0,0x7fffffff]-interval.
    --! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    --! @param    generator Pseudo Random Number Generator.
    --! @param    number    Generated random number.
    -------------------------------------------------------------------------------
    procedure GENERATE_RANDOM_INT31(
        variable generator : inout PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE;
        variable number    : out   integer
    );
    -------------------------------------------------------------------------------
    --! @brief Generates a random number on [0,1]-real-interval.
    --! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    --! @param    generator Pseudo Random Number Generator.
    --! @param    number    Generated random number.
    -------------------------------------------------------------------------------
    procedure GENERATE_RANDOM_REAL1(
        variable generator : inout PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE;
        variable number    : out   real
    );
    -------------------------------------------------------------------------------
    --! @brief Generates a random number on [0,1)-real-interval.
    --! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    --! @param    generator Pseudo Random Number Generator.
    --! @param    number    Generated random number.
    -------------------------------------------------------------------------------
    procedure GENERATE_RANDOM_REAL2(
        variable generator : inout PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE;
        variable number    : out   real
    );
    -------------------------------------------------------------------------------
    --! @brief Generates a random number on (0,1)-real-interval.
    --! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    --! @param    generator Pseudo Random Number Generator.
    --! @param    number    Generated random number.
    -------------------------------------------------------------------------------
    procedure GENERATE_RANDOM_REAL3(
        variable generator : inout PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE;
        variable number    : out   real
    );
end     XSADD;
-----------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
package body XSADD is
    -------------------------------------------------------------------------------
    -- Period parameters
    -------------------------------------------------------------------------------
    constant  SH1             : integer :=  15;
    constant  SH2             : integer :=  18;
    constant  SH3             : integer :=  11;
    constant  MIN_LOOP        : integer :=   8;
    constant  PRE_LOOP        : integer :=   8;
    -------------------------------------------------------------------------------
    --! @brief Convert Integer to SEED_TYPE
    --! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    --! @param    arg       Integer.
    --! @return             Generated seed number.
    -------------------------------------------------------------------------------
    function  TO_SEED_TYPE(arg:integer) return SEED_TYPE is
    begin
        return to_unsigned(arg,SEED_TYPE'length);
    end function;
    -------------------------------------------------------------------------------
    --! @brief Convert Integer to RANDOM_NUMBER_TYPE
    --! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    --! @param    arg       Integer.
    --! @return             Generated random number.
    -------------------------------------------------------------------------------
    function  TO_RANDOM_NUMBER_TYPE(arg:integer) return RANDOM_NUMBER_TYPE is
    begin
        return to_unsigned(arg,RANDOM_NUMBER_TYPE'length);
    end function;
    -------------------------------------------------------------------------------
    --! @brief Convert from Random Number to real.
    ---------------------------------------------------------------------------
    function  TO_REAL(arg:RANDOM_NUMBER_TYPE) return real is
        variable result: real := 0.0;
    begin
        for i in arg'range loop
            result := result + result;
            if (arg(i) = '1') then
                result := result + 1.0;
            end if;
        end loop;
        return result;
    end function;
    -------------------------------------------------------------------------------
    --! @brief RANDOM_NUMBER_TYPE multiplied by integer.
    -------------------------------------------------------------------------------
    function MUL_K(k:integer;arg:RANDOM_NUMBER_TYPE) return RANDOM_NUMBER_TYPE is
        variable tmp : unsigned(2*RANDOM_NUMBER_TYPE'length-1 downto 0);
    begin
        tmp := arg * TO_RANDOM_NUMBER_TYPE(k);
        return tmp(RANDOM_NUMBER_TYPE'range);
    end function;
    -------------------------------------------------------------------------------
    --! @brief Generate instance for Pseudo Random Number Generator.
    --! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    --! @param    seed      Seed Number for Pseudo Random Number Generator.
    --! @return             Pseudo Random Number Generator.
    -------------------------------------------------------------------------------
    function  NEW_PSEUDO_RANDOM_NUMBER_GENERATOR(
        seed    : SEED_TYPE
    )   return    PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE
    is
        variable generator : PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE;
    begin
        INIT_PSEUDO_RANDOM_NUMBER_GENERATOR(generator,seed);
        return generator;
    end function;
    -------------------------------------------------------------------------------
    --! @brief Generate instance for Pseudo Random Number Generator.
    --! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    --! @param    seed      Seed Number Vector for Pseudo Random Number Generator.
    --! @return             Pseudo Random Number Generator.
    -------------------------------------------------------------------------------
    function  NEW_PSEUDO_RANDOM_NUMBER_GENERATOR(
        seed    : SEED_VECTOR
    )   return    PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE
    is
        variable generator : PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE;
    begin
        INIT_PSEUDO_RANDOM_NUMBER_GENERATOR(generator,seed);
        return generator;
    end function;
    -------------------------------------------------------------------------------
    --! @brief This function certificate the period of 2^127-1.
    -------------------------------------------------------------------------------
    procedure period_certification(generator:inout PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE) is
    begin 
        if ((generator.status(0) = 0) and
            (generator.status(1) = 0) and
            (generator.status(2) = 0) and
            (generator.status(3) = 0)) then
             generator.status(0) := TO_RANDOM_NUMBER_TYPE(character'pos('X'));
	     generator.status(1) := TO_RANDOM_NUMBER_TYPE(character'pos('S'));
	     generator.status(2) := TO_RANDOM_NUMBER_TYPE(character'pos('A'));
	     generator.status(3) := TO_RANDOM_NUMBER_TYPE(character'pos('D'));
        end if;
    end procedure;
    -------------------------------------------------------------------------------
    --! @brief Initialize Pseudo Random Number Generator.
    --! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    --! @param    generator Pseudo Random Number Generator.
    --! @param    seed      Seed Number for Pseudo Random Number Generator.
    -------------------------------------------------------------------------------
    procedure INIT_PSEUDO_RANDOM_NUMBER_GENERATOR(
        variable generator : inout PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE;
                 seed      : in    SEED_TYPE
    ) is
    begin 
        generator.status(0) := seed;
        generator.status(1) := TO_RANDOM_NUMBER_TYPE(0);
        generator.status(2) := TO_RANDOM_NUMBER_TYPE(0);
        generator.status(3) := TO_RANDOM_NUMBER_TYPE(0);
        for i in 1 to MIN_LOOP-1 loop
            generator.status(i mod 4) := generator.status(i mod 4) xor
                                         (MUL_K(1812433253,
                                               ((generator.status((i-1) mod 4)) xor
                                                (generator.status((i-1) mod 4) srl 30))) + i);
        end loop;
        period_certification(generator);
        for i in 0 to PRE_LOOP-1 loop
           NEXT_PSEUDO_RANDOM_NUMBER_GENERATOR(generator);
        end loop;
    end procedure;
    -------------------------------------------------------------------------------
    --! @brief Initialize Pseudo Random Number Generator.
    --! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    --! @param    generator Pseudo Random Number Generator.
    --! @param    seed      Seed Number Vector for Pseudo Random Number Generator.
    -------------------------------------------------------------------------------
    procedure INIT_PSEUDO_RANDOM_NUMBER_GENERATOR(
        variable generator : inout PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE;
                 seed      : in    SEED_VECTOR
    ) is
        constant lag       : integer := 1;
        constant mid       : integer := 1;
        constant size      : integer := 4;
        variable i,j       : integer;
        variable count     : integer;
        variable r         : RANDOM_NUMBER_TYPE;
        alias    init_key  : SEED_VECTOR(1 to seed'length) is seed;
        function ini_func1(x:RANDOM_NUMBER_TYPE) return RANDOM_NUMBER_TYPE is
        begin 
            return MUL_K(1664525   ,(x xor (x srl 27)));
        end function;
        function ini_func2(x:RANDOM_NUMBER_TYPE) return RANDOM_NUMBER_TYPE is
        begin 
            return MUL_K(1566083941,(x xor (x srl 27)));
        end function;
    begin
        generator.status(0) := TO_RANDOM_NUMBER_TYPE(0);
        generator.status(1) := TO_RANDOM_NUMBER_TYPE(0);
        generator.status(2) := TO_RANDOM_NUMBER_TYPE(0);
        generator.status(3) := TO_RANDOM_NUMBER_TYPE(0);
        if (init_key'length + 1 > MIN_LOOP) then
            count := init_key'length + 1;
        else
            count := MIN_LOOP;
        end if;
        i := 0;
        for j in 0 to count-1 loop
            r := ini_func1(generator.status(i) xor
                           generator.status((i+mid) mod size) xor
                           generator.status((i+size-1) mod size));
            generator.status((i+mid    ) mod size) := generator.status((i+mid    ) mod size) + r;
            if    (j = 0) then
                r := r + init_key'length;
            elsif (init_key'low <= j and j <= init_key'high) then
                r := r + init_key(j) + i;
            else
                r := r + i;
            end if;
            generator.status((i+mid+lag) mod size) := generator.status((i+mid+lag) mod size) + r;
            generator.status(i) := r;
            i := (i + 1) mod size;
        end loop;
        for j in 0 to size-1 loop
            r := ini_func2(generator.status(i) +
                           generator.status((i+mid   ) mod size) +
                           generator.status((i+size-1) mod size));
            generator.status((i+mid    ) mod size) := generator.status((i+mid    ) mod size) xor r;
            r := r - i;
            generator.status((i+mid+lag) mod size) := generator.status((i+mid+lag) mod size) xor r;
            generator.status(i) := r;
            i := (i + 1) mod size;
        end loop;
        period_certification(generator);
        for i in 0 to PRE_LOOP-1 loop
            NEXT_PSEUDO_RANDOM_NUMBER_GENERATOR(generator);
        end loop;
    end procedure;
    -------------------------------------------------------------------------------
    --! @brief This function changes internal state of tinymt32.
    --! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    --! * Users should not call this function directly.
    --! @param    generator Pseudo Random Number Generator.
    -------------------------------------------------------------------------------
    procedure NEXT_PSEUDO_RANDOM_NUMBER_GENERATOR(
        variable generator  : inout PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE
    ) is
        variable t          :       RANDOM_NUMBER_TYPE;
    begin
        t := generator.status(0);
        t := t xor (t sll SH1);
        t := t xor (t srl SH2);
        t := t xor (generator.status(3) sll SH3);
        generator.status(0) := generator.status(1);
        generator.status(1) := generator.status(2);
        generator.status(2) := generator.status(3);
        generator.status(3) := t;
    end procedure;
    -------------------------------------------------------------------------------
    --! @brief This function outputs 32-bit unsigned integer from internal state.
    --! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    --! * Users should not call this function directly.
    --! @param    generator Pseudo Random Number Generator.
    --! @return             Generated temper number.
    -------------------------------------------------------------------------------
    function GENERATE_TEMPER(
                 generator  :       PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE
    )            return             RANDOM_NUMBER_TYPE
    is
    begin
        return generator.status(3) + generator.status(2);
    end function;
    -------------------------------------------------------------------------------
    --! @brief Generates a random number
    --! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    --! @param    generator Pseudo Random Number Generator.
    --! @param    number    Generated random number.
    -------------------------------------------------------------------------------
    procedure GENERATE_RANDOM_NUMBER(
        variable generator : inout PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE;
        variable number    : out   RANDOM_NUMBER_TYPE
    ) is
    begin 
        NEXT_PSEUDO_RANDOM_NUMBER_GENERATOR(generator);
        number := GENERATE_TEMPER(generator);
    end procedure;
    -------------------------------------------------------------------------------
    --! @brief Generates a random number on (std_logic_vector).
    --! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    --! @param    generator Pseudo Random Number Generator.
    --! @param    number    Generated random number.
    -------------------------------------------------------------------------------
    procedure GENERATE_RANDOM_STD_LOGIC_VECTOR(
        variable generator : inout PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE;
        variable number    : out   std_logic_vector
    ) is
        variable word      :       RANDOM_NUMBER_TYPE;
        variable number_t  :       std_logic_vector(number'length-1 downto 0);
    begin
        NEXT_PSEUDO_RANDOM_NUMBER_GENERATOR(generator);
        word := GENERATE_TEMPER(generator);
        for i in number_t'range loop
            if (word(i) = '1') then
                number_t(i) := '1';
            else
                number_t(i) := '0';
            end if;
        end loop;  
        number := number_t;
    end procedure;
    -------------------------------------------------------------------------------
    --! @brief Generates a random number on [0,0x7fffffff]-interval.
    --! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    --! @param    generator Pseudo Random Number Generator.
    --! @param    number    Generated random number.
    -------------------------------------------------------------------------------
    procedure GENERATE_RANDOM_INT31(
        variable generator : inout PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE;
        variable number    : out   integer
    ) is
        variable word      :       RANDOM_NUMBER_TYPE;
    begin
        NEXT_PSEUDO_RANDOM_NUMBER_GENERATOR(generator);
        word := GENERATE_TEMPER(generator);
        number := to_integer(word(31 downto 1));
    end procedure;
    -------------------------------------------------------------------------------
    --! @brief Generates a random number on [0,1]-real-interval.
    --! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    --! @param    generator Pseudo Random Number Generator.
    --! @param    number    Generated random number.
    -------------------------------------------------------------------------------
    procedure GENERATE_RANDOM_REAL1(
        variable generator : inout PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE;
        variable number    : out   real
    ) is
        variable word      :       RANDOM_NUMBER_TYPE;
    begin
        NEXT_PSEUDO_RANDOM_NUMBER_GENERATOR(generator);
        word := GENERATE_TEMPER(generator);
        number := (1.0/4294967295.0)*TO_REAL(word);
    end procedure;
    -------------------------------------------------------------------------------
    --! @brief Generates a random number on [0,1)-real-interval.
    --! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    --! @param    generator Pseudo Random Number Generator.
    --! @param    number    Generated random number.
    -------------------------------------------------------------------------------
    procedure GENERATE_RANDOM_REAL2(
        variable generator : inout PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE;
        variable number    : out   real
    ) is
        variable word      :       RANDOM_NUMBER_TYPE;
    begin
        NEXT_PSEUDO_RANDOM_NUMBER_GENERATOR(generator);
        word := GENERATE_TEMPER(generator);
        number := (1.0/4294967296.0)*TO_REAL(word);
    end procedure;
    -------------------------------------------------------------------------------
    --! @brief Generates a random number on (0,1)-real-interval.
    --! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    --! @param    generator Pseudo Random Number Generator.
    --! @param    number    Generated random number.
    -------------------------------------------------------------------------------
    procedure GENERATE_RANDOM_REAL3(
        variable generator : inout PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE;
        variable number    : out   real
    ) is
        variable word      :       RANDOM_NUMBER_TYPE;
    begin
        NEXT_PSEUDO_RANDOM_NUMBER_GENERATOR(generator);
        word := GENERATE_TEMPER(generator);
        number := (1.0/4294967296.0)*(0.5+TO_REAL(word));
    end procedure;
end     XSADD;
