library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
library XSADD;
entity  SAMPLE is
    generic (L: integer := 1);
    port    (
        CLK         : in  std_logic;
        RST         : in  std_logic;
        RND_VAL     : out std_logic;
        RND_OUT     : out std_logic_vector(31 downto 0);
        RND_RDY     : in  std_logic
    );
end     SAMPLE;
architecture RTL of SAMPLE is
    constant   INIT_SEED   :  integer   := 1234;
    constant   tbl_init    :  std_logic := '0';
    constant   tbl_wdata   :  std_logic_vector(127 downto 0) := (others => '0');
    signal     tbl_rdata   :  std_logic_vector(127 downto 0);
    constant   rnd_run     :  std_logic := '1';
    signal     rnd_valid   :  std_logic;
    signal     rnd_num     :  std_logic_vector(32*L-1 downto 0);
    signal     rnd_reg     :  std_logic_vector(32*L-1 downto 0);
begin
    U: entity XSADD.XSADD_RAND_GEN
        generic map(
            SEED        => INIT_SEED,
            L           => L
        )
        port map(
            CLK         => CLK      ,
            RST         => RST      ,
            TBL_INIT    => tbl_init ,
            TBL_WDATA   => tbl_wdata,
            TBL_RDATA   => tbl_rdata,
            RND_RUN     => rnd_run  ,
            RND_NUM     => rnd_num  ,
            RND_VAL     => rnd_valid,
            RND_RDY     => RND_RDY
        );
    process(CLK,RST) begin
        if (RST = '1') then
                rnd_reg <= (others => '0');
        elsif (CLK'event and CLK = '1') then
            if  (rnd_valid = '1' and RND_RDY = '1') then
                rnd_reg <= rnd_num;
            elsif (L > 1) then
                for i in 0 to L-2 loop
                    rnd_reg(32*i+31 downto 32*i) <= rnd_reg(32*(i+1)+31 downto 32*(i+1));
                end loop;
            end if;
        end if;
    end process;
    RND_OUT <= rnd_reg(31 downto 0);
end  RTL;
