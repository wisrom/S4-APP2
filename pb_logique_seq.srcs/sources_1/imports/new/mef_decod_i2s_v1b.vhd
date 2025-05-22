---------------------------------------------------------------------------------------------
-- circuit mef_decod_i2s_v1b.vhd                   Version mise en oeuvre avec des compteurs
---------------------------------------------------------------------------------------------
-- Université de Sherbrooke - Département de GEGI
-- Version         : 1.0
-- Nomenclature    : 0.8 GRAMS
-- Date            : 7 mai 2019
-- Auteur(s)       : Daniel Dalle
-- Technologies    : FPGA Zynq (carte ZYBO Z7-10 ZYBO Z7-20)
--
-- Outils          : vivado 2019.1
--------------------------------------------------------------------------------------------
-- Description:
-- MEF pour decodeur I2S version 1b
-- La MEF est substituee par un compteur
--
-- notes
-- frequences (peuvent varier un peu selon les contraintes de mise en oeuvre)
-- i_lrc        ~ 48.    KHz    (~ 20.8    us)
-- d_ac_mclk,   ~ 12.288 MHz    (~ 80,715  ns) (non utilisee dans le codeur)
-- i_bclk       ~ 3,10   MHz    (~ 322,857 ns) freq mclk/4
-- La durée d'une période reclrc est de 64,5 périodes de bclk ...
--
-- Revision  
-- Revision 14 mai 2019 (version ..._v1b) composants dans entités et fichiers distincts
---------------------------------------------------------------------------------------------
-- À faire :
--
--
---------------------------------------------------------------------------------------------
 
 
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;  -- pour les additions dans les compteurs
 
entity mef_decod_i2s_v1b is
   Port ( 
   i_bclk      : in std_logic;
   i_reset     : in    std_logic; 
   i_lrc       : in std_logic;
   i_cpt_bits  : in std_logic_vector(6 downto 0);
--  
   o_bit_enable     : out std_logic ;  --
   o_load_left      : out std_logic ;  --
   o_load_right     : out std_logic ;  --
   o_str_dat        : out std_logic ;  --  
   o_cpt_bit_reset  : out std_logic   -- 
);
end mef_decod_i2s_v1b;
 
architecture Behavioral of mef_decod_i2s_v1b is
 
    signal   d_reclrc_prec  : std_logic ;  --
    type etats is (
        E0,
        E1,
        E2,
        E3,
        E4,
        E5,
        E6,
        E7
    );
    signal etat_courant, nouvel_etat : etats;
begin
 
 reglrc_I2S: process ( i_bclk)
   begin
   if i_bclk'event and (i_bclk = '1') then
        d_reclrc_prec <= i_lrc;
   end if;
   end process;

 rest_cpt: process (i_lrc, d_reclrc_prec, i_reset)

      begin

         o_cpt_bit_reset <= (d_reclrc_prec xor i_lrc) or i_reset;

      end process;
 
    update_state: process(i_bclk)
    begin
       if (i_reset = '1') then
             etat_courant <= E0;
       else
       if rising_edge(i_bclk) then
             etat_courant <= nouvel_etat;
       end if;
       end if;
    end process;
   
    transion: process(i_lrc , etat_courant, i_cpt_bits)
    begin
        case etat_courant is 
            when E0 =>
                if(i_lrc = '1') then
                    nouvel_etat <= E0; -- keep waiting
                else
                    nouvel_etat <= E1; -- change state
                end if;
            when E1 =>
                if(i_cpt_bits /= "0010111") then -- counter hasnt reached value of [24]
                    nouvel_etat <= E1; -- keep waiting
                else
                    nouvel_etat <= E2; -- change state
                end if;
            when E2 =>
                nouvel_etat <= E3; -- change state
            when E3 =>
                nouvel_etat <= E4; -- change state
            when E4 =>
                if(i_lrc = '0') then
                    nouvel_etat <= E4; -- keep waiting
                else
                    nouvel_etat <= E5; -- change state
                end if;
            when E5 =>
                if(i_cpt_bits /= "0010111") then -- counter hasnt reached value of [24]
                    nouvel_etat <= E5; -- keep waiting
                else
                    nouvel_etat <= E6; -- change state
                end if;
            when E6 =>
                nouvel_etat <= E7; -- change state
            when E7 =>
                nouvel_etat <= E0; -- change state
            when others =>
                nouvel_etat <= E0; -- reset to default state
        end case;
    end process;
    
    apply: process(etat_courant)
    begin
        case etat_courant is 
            when E0 =>
                o_cpt_bit_reset <= '1';
                o_bit_enable    <= '0';
                o_load_left     <= '0';
                o_load_right    <= '0';
                o_str_dat       <= '0';
            when E1 =>
                o_cpt_bit_reset <= '0';
                o_bit_enable    <= '1';
                o_load_left     <= '0';
                o_load_right    <= '0';
                o_str_dat       <= '0';
            when E2 =>
                o_cpt_bit_reset <= '0';
                o_bit_enable    <= '0';
                o_load_left     <= '1';
                o_load_right    <= '0';
                o_str_dat       <= '0';
            when E3 => --wait
                o_cpt_bit_reset <= '0';
                o_bit_enable    <= '0';
                o_load_left     <= '0';
                o_load_right    <= '0';
                o_str_dat       <= '0';
            when E4 =>
                o_cpt_bit_reset <= '1';
                o_bit_enable    <= '0';
                o_load_left     <= '0';
                o_load_right    <= '0';
                o_str_dat       <= '0';
            when E5 =>
                o_cpt_bit_reset <= '0';
                o_bit_enable    <= '1';
                o_load_left     <= '0';
                o_load_right    <= '0';
                o_str_dat       <= '0';
            when E6 =>
                o_cpt_bit_reset <= '0';
                o_bit_enable    <= '0';
                o_load_left     <= '0';
                o_load_right    <= '1';
                o_str_dat       <= '0';
            when E7 =>
                o_cpt_bit_reset <= '0';
                o_bit_enable    <= '0';
                o_load_left     <= '0';
                o_load_right    <= '0';
                o_str_dat       <= '1';
            when others =>
                o_cpt_bit_reset <= '1';
                o_bit_enable    <= '0';
                o_load_left     <= '0';
                o_load_right    <= '0';
                o_str_dat       <= '0';
        end case;
    end process;
 
 
end Behavioral;