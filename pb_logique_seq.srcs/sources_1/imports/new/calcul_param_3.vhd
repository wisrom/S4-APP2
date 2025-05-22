
---------------------------------------------------------------------------------------------
--    calcul_param_3.vhd 
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
--    Universit� de Sherbrooke - D�partement de GEGI
--
--    Version         : 6.0
--    Nomenclature    : inspiree de la nomenclature 0.2 GRAMS
--    Date            : 29 janvier 2019, rev 13 f�vrier
--                    : revision 4 mai 2020 �limination de i_lrc
--    Auteur(s)       : Daniel Dalle
--    Technologie     : ZYNQ 7000 Zybo Z7-10 (xc7z010clg400-1) 
--    Outils          : vivado 2018.2 64 bits
--
---------------------------------------------------------------------------------------------
--  Description 
--  Le troisi�me param�tre consiste � extraire la valeur pic de l'amplitude
--  du signal dans une fen�tre glissante couvrant les 48 �chantillons les plus r�cents. 
---------------------------------------------------------------------------------------------
--
--
---------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;  -- pour les additions dans les compteurs
USE ieee.numeric_std.ALL;
--use IEEE.std_logic_arith.all;     -- requis pour les constantes  etc.
--use IEEE.std_logic_arith.all;     -- requis pour les constantes telles que cdviv6 etc.
Library UNISIM;
use UNISIM.vcomponents.all;

----------------------------------------------------------------------------------
-- **************************************************************************** --
----------------------------------------------------------------------------------
entity calcul_param_3 is
    Port (
    i_bclk    : in   std_logic;          -- bit clock
    i_reset   : in   std_logic;          --
    i_en      : in   std_logic;          -- indique un echantillon present
 --   i_lrc     : in   std_logic;          -- "Left-Right clock" (I2S)
    i_ech     : in   std_logic_vector (23 downto 0);  -- valide si en = '1'
    o_param   : out  std_logic_vector (7 downto 0)    -- valeur param�tre evalu�e                               
    );
end calcul_param_3;


----------------------------------------------------------------------------------


architecture Behavioral of calcul_param_3 is

---------------------------------------------------------------------------------
-- Signaux
----------------------------------------------------------------------------------
    

---------------------------------------------------------------------------------------------
--    Description comportementale
---------------------------------------------------------------------------------------------
begin 
-- PAS BESOIN D'IMPL�MENTER CE PARAM�TRE
-- PAS BESOIN D'IMPL�MENTER CE PARAM�TRE
-- PAS BESOIN D'IMPL�MENTER CE PARAM�TRE
-- PAS BESOIN D'IMPL�MENTER CE PARAM�TRE
-- PAS BESOIN D'IMPL�MENTER CE PARAM�TRE
-- PAS BESOIN D'IMPL�MENTER CE PARAM�TRE
-- PAS BESOIN D'IMPL�MENTER CE PARAM�TRE
-- PAS BESOIN D'IMPL�MENTER CE PARAM�TRE
-- PAS BESOIN D'IMPL�MENTER CE PARAM�TRE
-- PAS BESOIN D'IMPL�MENTER CE PARAM�TRE
-- PAS BESOIN D'IMPL�MENTER CE PARAM�TRE
-- PAS BESOIN D'IMPL�MENTER CE PARAM�TRE
     o_param <= x"03";    -- temporaire ...

end Behavioral;
