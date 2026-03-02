library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library surf;
use surf.StdRtlPkg.all;

library aes;
use aes.AesGf2Pkg.all;

entity tb_aes is
end tb_aes;

architecture sim of tb_aes is
    signal key  : slv(127 downto 0) := x"000102030405060708090A0B0C0D0E0F";
    signal rcon : slv(31 downto 0)  := x"01000000";
    signal rk   : slv(127 downto 0);
begin

    process
    begin
        rk <= keyExpansion(key, rcon);

        report "Round key = " & to_hstring(rk);

        wait;
    end process;

end architecture;