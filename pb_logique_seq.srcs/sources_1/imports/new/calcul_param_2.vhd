-- À FAIRE: 
-- Voir le guide de la problématique
---------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------------

----    calcul_param_2.vhd   (temporaire)

-----------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------

----    Université de Sherbrooke - Département de GEGI

----

----    Version         : 5.0

----    Nomenclature    : inspiree de la nomenclature 0.2 GRAMS

----    Date            : 16 janvier 2020, 4 mai 2020

----    Auteur(s)       : 

----    Technologie     : ZYNQ 7000 Zybo Z7-10 (xc7z010clg400-1) 

----    Outils          : vivado 2019.1 64 bits

----

-----------------------------------------------------------------------------------------------

----    Description (sur une carte Zybo)

-----------------------------------------------------------------------------------------------

----

-----------------------------------------------------------------------------------------------

---- À FAIRE: 

---- Voir le guide de la problématique

-----------------------------------------------------------------------------------------------

----

-----------------------------------------------------------------------------------------------
 
--library IEEE;

--use IEEE.STD_LOGIC_1164.ALL;

--use IEEE.STD_LOGIC_UNSIGNED.ALL;  -- pour les additions dans les compteurs

--use IEEE.std_logic_unsigned.all;

--USE ieee.numeric_std.ALL;

--Library UNISIM;

--use UNISIM.vcomponents.all;
 
--------------------------------------------------------------------------------------

------ 

--------------------------------------------------------------------------------------

--entity calcul_param_2 is

--    Port (

--        i_bclk   : in  std_logic;                         -- horloge bit (I2S)

--        i_reset  : in  std_logic;                         -- réinitialisation

--        i_en     : in  std_logic;                         -- nouvel échantillon présent

--        i_ech    : in  std_logic_vector(23 downto 0);     -- échantillon d'entrée

--        o_param  : out std_logic_vector(7 downto 0)       -- paramètre calculé

--    );

--end calcul_param_2;
 
--architecture Behavioral of calcul_param_2 is
 
--   -- États du système

--    type etats is (

--        E0,  -- État initial

--        E1,  -- État puissance 2

--        E2,  -- État calcul

--        E3   -- État résultat

--  );

--   signal etat_courant, nouvel_etat : etats;
 
--   signal a : std_logic_vector(47 downto 0) := (others => '0');

--   signal b : std_logic_vector(47 downto 0) := (others => '0');

--   signal c : std_logic_vector(52 downto 0) := (others => '0');
 
--begin
 
--   update: process(i_bclk)

--   begin

--      if (i_reset = '1') then

--             etat_courant <= E0;

--      else

--       if rising_edge(i_bclk) then

--             etat_courant <= nouvel_etat;

--      end if;

--      end if;

--    end process;
 
 
--   transition : process(etat_courant, i_en, i_ech) 

--    begin

--    case etat_courant is 

--       when E0 =>

--          if i_en = '1' then

--               nouvel_etat <= E1;  -- Vers état puissance 2

--            else 

--                nouvel_etat <= E0;  -- Retour à état initial

--            end if;

--        when E1 =>

--                nouvel_etat <= E2;  -- Vers état calcul 

--        when E2 => 

--                nouvel_etat <= E3;  -- Vers état résultat

--        when E3 =>

--          if rising_edge(i_en) then

--                nouvel_etat <= E1;  -- Retour à puissance 2

--          end if;

--        when others =>

--                nouvel_etat <= E0;  -- Retour à état initial

--      end case;

--    end process;
 
--    apply : process(etat_courant, i_ech, a, b, c)

--    begin

--    case etat_courant is 

--        when E0 =>

--            a <= (others => '0');

--            b <= (others => '0');

--            c <= (others => '0');

--        when E1 =>

--            a <= std_logic_vector(signed(i_ech) * signed(i_ech));  -- Produit des valeur i_ech

--            c <= b * "11111";  -- Multiplication par 31

--        when E2 =>

--            b <= a + c(52 downto 5);  -- Bits shift de 5 pour représenter /32

--        when E3 =>

--            o_param <= b(47 downto 40); -- remettre la sortie sur 8 Bits avec les MSB

--        when others =>

--            a <= (others => '0');

--            b <= (others => '0');

--            c <= (others => '0');                    

--     end case;

--    end process;

--end Behavioral;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;  -- pour les additions dans les compteurs
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.vcomponents.all;

entity calcul_param_2 is
    Port (
        i_bclk    : in  std_logic;   -- bit clock
        i_reset   : in  std_logic;
        i_en      : in  std_logic;   -- un echantillon present
        i_ech     : in  std_logic_vector(23 downto 0);
        o_param   : out std_logic_vector(7 downto 0)
    );
end calcul_param_2;



architecture Behavioral of calcul_param_2 is

    -- États de la machine
    type TypeEtat is (etat_init, etat_puiss, etat_add, etat_sortie);
    signal etat_actuel, etat_suivant : TypeEtat := etat_init;

    -- Signaux internes renommés
    signal reg_old_val  : unsigned(47 downto 0) := (others => '0');
    signal reg_carre    : std_logic_vector(47 downto 0) := (others => '0');
    signal reg_mul_temp : std_logic_vector(52 downto 0) := (others => '0');
    constant cst_mult   : std_logic_vector(4 downto 0) := "11111";

begin

    -- Processus d'horloge pour changer d'état
    p_changement_etat : process(i_bclk, i_reset)
    begin
        if (i_reset = '1') then
            etat_actuel <= etat_init;
        elsif rising_edge(i_bclk) then
            etat_actuel <= etat_suivant;
        end if;
    end process;

    -- Processus de transition d'état
    p_transition : process(i_en, i_ech, etat_actuel)
    begin
        case etat_actuel is
            when etat_init =>
                if i_en = '1' then
                    etat_suivant <= etat_puiss;
                else
                    etat_suivant <= etat_init;
                end if;

            when etat_puiss =>
                etat_suivant <= etat_add;

            when etat_add =>
                etat_suivant <= etat_sortie;

            when etat_sortie =>
                if i_en'event and i_en = '1' then
                    etat_suivant <= etat_puiss;
                end if;

            when others =>
                etat_suivant <= etat_init;
        end case;
    end process;

    -- Processus principal de calcul
    p_calcul : process(i_ech, etat_actuel, reg_carre, reg_old_val, reg_mul_temp)
    begin
        case etat_actuel is
            when etat_init =>
                reg_carre    <= (others => '0');
                reg_mul_temp <= (others => '0');
                reg_old_val  <= (others => '0');

            when etat_puiss =>
                reg_carre    <= std_logic_vector(signed(i_ech) * signed(i_ech));
                reg_mul_temp <= std_logic_vector(reg_old_val) * cst_mult;

            when etat_add =>
                reg_old_val <= shift_right(unsigned(reg_carre), 1) +
                               shift_right(unsigned(reg_mul_temp(52 downto 5)), 1);

            when etat_sortie =>
                o_param <= std_logic_vector(reg_old_val(47 downto 40));

            when others =>
                reg_carre    <= (others => '0');
                reg_mul_temp <= (others => '0');
                reg_old_val  <= (others => '0');
        end case;
    end process;

end Behavioral;
 