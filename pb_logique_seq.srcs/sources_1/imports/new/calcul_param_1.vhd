---------------------------------------------------------------------------------------------
--    calcul_param_1.vhd
---------------------------------------------------------------------------------------------
--    Université de Sherbrooke - Département de GEGI
--
--    Version         : 5.0
--    Nomenclature    : Inspirée de la nomenclature 0.2 GRAMS
--    Date            : 16 janvier 2020, 4 mai 2020
--    Auteur(s)       : 
--    Technologie     : ZYNQ 7000 Zybo Z7-10 (xc7z010clg400-1) 
--    Outils          : Vivado 2019.1 64 bits
---------------------------------------------------------------------------------------------
--    Description (pour une carte Zybo)
--    Ce module effectue un traitement sur les échantillons entrants pour calculer un paramètre.
---------------------------------------------------------------------------------------------
--    À FAIRE : 
--    Voir le guide de la problématique
---------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;  -- Utilisé pour les additions dans les compteurs (à remplacer par `numeric_std` si possible)
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.vcomponents.all;

---------------------------------------------------------------------------------------------
--    Entité : calcul_param_1
--    Entrées :
--        i_bclk  : horloge bit (I2S)
--        i_reset : réinitialisation asynchrone
--        i_en    : indique qu'un nouvel échantillon est présent à l'entrée
--        i_ech   : échantillon audio en entrée (24 bits)
--    Sorties :
--        o_param : paramètre calculé (8 bits)
---------------------------------------------------------------------------------------------
entity calcul_param_1 is
    Port (
        i_bclk   : in  std_logic;                         -- horloge bit (I2S)
        i_reset  : in  std_logic;                         -- réinitialisation
        i_en     : in  std_logic;                         -- nouvel échantillon présent
        i_ech    : in  std_logic_vector(23 downto 0);     -- échantillon d'entrée
        o_param  : out std_logic_vector(7 downto 0)       -- paramètre calculé
    );
end calcul_param_1;

architecture Behavioral of calcul_param_1 is

    -- États du système
    type etats is (
        E0,  -- État initial
        E1,  -- État compteur
        E2,  -- État de vérification
        E3   -- État multiplication par 2
    );
    signal etat_courant, nouvel_etat : etats;

    Signal compteur: std_logic_vector(6 downto 0);
    Signal reset_compteur: std_logic;
    signal enable_compteur: std_logic;


begin 
    
    update: process(i_bclk, i_reset)
    begin
       if (i_reset = '1') then
             etat_courant <= E0;
             --o_param <= (others =>'0');
       else
       if rising_edge(i_bclk) then
             etat_courant <= nouvel_etat;
       end if;
       end if;
    end process;
    
    Counter : process(enable_compteur, reset_compteur, i_bclk, i_en)
    begin
    if (reset_compteur = '1') then
        compteur <= (others =>'0'); 
    elsif(enable_compteur = '1' and i_en'event and i_en = '1' and i_ech(23) = '0') then
    compteur <= compteur + 1;
      --if (enable_compteur = '1' and i_en = '1' and i_ech(23) = '0') then
            --compteur <= compteur + 1;
        --end if;
    end if;
    end process;
    
    transition : process(etat_courant, i_en, i_ech) 
    begin
    case etat_courant is 
        when E0 =>
            if i_en = '1' then
                nouvel_etat <= E1;  -- Vers état compteur
            else 
                nouvel_etat <= E0;  -- Retour à état initial
            end if;
        when E1 =>
            if i_en = '1' AND i_ech(23) = '1' then
                nouvel_etat <= E2;  -- Vers état de vérification 
            else 
                nouvel_etat <= E1;  -- Reste à état compteur
            end if;
        when E2 =>
        if ( compteur = "0000011" or compteur = "0000000" or compteur = "0000001" or compteur = "0000010") then
         nouvel_etat <= E0;
         else nouvel_etat <= E3;
         end if;
        when E3 =>
                nouvel_etat <= E0;  -- Retour à état initial
        when others =>
                nouvel_etat <= E0;  -- Retour à état initial
      end case;
    end process;

    apply : process(etat_courant, i_en, i_ech)
    begin
    case etat_courant is 
        when E0 =>
            enable_compteur <= '0';
            reset_compteur <= '1';
            --o_param <= (others =>'0');
        when E1 =>
            enable_compteur <= '1';
            reset_compteur <= '0';
        when E2 =>
            enable_compteur <= '0';
            reset_compteur <= '0';
         when E3 =>
            o_param(0) <= '0';  -- Décale de 1 vers la gauche => Multiplication par 2 
            o_param(7 downto 1) <= compteur;
         when others =>
            enable_compteur <= '0';
            reset_compteur <= '1';                       
     end case;
    end process;
    
    --o_param <= x"01";

end Behavioral;
--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;  -- pour les additions dans les compteurs
--USE ieee.numeric_std.ALL;
--Library UNISIM;
--use UNISIM.vcomponents.all;

------------------------------------------------------------------------------------
---- 
------------------------------------------------------------------------------------
--entity calcul_param_1 is
--    Port (
--    i_bclk    : in   std_logic; -- bit clock (I2S)
--    i_reset   : in   std_logic;
--    i_en      : in   std_logic; -- un echantillon present a l'entr?e
--    i_ech     : in   std_logic_vector (23 downto 0); -- echantillon en entr?e
--    o_param   : out  std_logic_vector (7 downto 0)   -- param?tre calcul?
--    );
--end calcul_param_1;

------------------------------------------------------------------------------------

--architecture Behavioral of calcul_param_1 is
----ajout d'un compteur
--component  compteur_nbits is
--generic (nbits : integer := 8);
--   port ( clk             : in    std_logic; 
--          i_en            : in    std_logic; 
--          reset           : in    std_logic; 
--          o_val_cpt       : out   std_logic_vector (nbits-1 downto 0)
--          );
--end component;

-----------------------------------------------------------------------------------
---- Signaux
------------------------------------------------------------------------------------


--    -- state list
-- type fsm_c_etats is (
--      sta_At,
--      sta_Va,
--      sta_Vb,
--      sta_Vc,
--      sta_Li,
--      sta_Lo,
--      sta_Se
--     );
--signal fsm_EtatCourant, fsm_prochainEtat : fsm_c_etats; -- conserve le state
--signal d_cpt : std_logic_vector (7 downto 0) := "00000000";

--signal  d_en, d_clk : std_logic;
--signal cpt_reset : std_logic := '0';
-----------------------------------------------------------------------------------------------
----    Description comportementale
-----------------------------------------------------------------------------------------------
--begin 
---- instance du compteur
--inst_cpt : compteur_nbits
-- Port map(
--    clk             => i_bclk,
--    i_en            => i_en,        
--    reset           => cpt_reset, 
--    o_val_cpt       => d_cpt 
-- );
----Actualise le state
--    process(i_bclk, i_reset)
--    begin
--       if (i_reset ='1') then
--             fsm_EtatCourant <= sta_At;
--       else
--       if rising_edge(i_bclk) then
--             fsm_EtatCourant <= fsm_prochainEtat;
--       end if;
--       end if;
--end process;

----MEF M5
--    process(i_bclk)
--    begin
--    if i_en ='1' then 
--        if i_reset ='1' then
--            fsm_prochainEtat <= sta_At;
--        end if;
--        case fsm_EtatCourant is

--            when sta_At =>
--                cpt_reset <= '0';
--                if(i_ech(23) ='1') then
--                    fsm_prochainEtat <= sta_At;
--                elsif(i_ech(23) = '0') then 
--                    fsm_prochainEtat <= sta_Va;
--                end if;
--            when sta_Va =>
--                if(i_ech(23) = '0') then 
--                    fsm_prochainEtat <= sta_Vb;
--                else
--                    fsm_prochainEtat <= sta_At;                    
--                end if;
--            when sta_Vb =>
--                if(i_ech(23) = '0') then  
--                    fsm_prochainEtat <= sta_Vc;
--                else
--                    fsm_prochainEtat <= sta_At;      
--                end if;
--            when sta_Vc =>
--                if(i_ech(23) = '0') then  
--                    fsm_prochainEtat <= sta_Li;
--                else
--                    fsm_prochainEtat <= sta_At;      
--                end if;           
--            when sta_Li =>
--                if(i_ech(23)='1') then
--                    fsm_prochainEtat <= sta_Lo;
--                else 
--                    fsm_prochainEtat <= sta_Li;
--                end if;
--           when sta_Lo =>
--                if(i_ech(23)='1') then
--                    fsm_prochainEtat <= sta_Lo;
--                else 
--                    fsm_prochainEtat <= sta_Se;
--                end if;
--          when sta_Se =>
--            fsm_prochainEtat <= sta_At;
--            cpt_reset <= '1';
--        end case; 
--      end if;  
--    end process;
--    process(fsm_EtatCourant,d_cpt)
--    begin
--    case fsm_EtatCourant is
--        when sta_Se =>
--        o_param <= (d_cpt-1); -- On envoie les donnes pour etre afficher
--        cpt_reset <= '1';
        
--        when others =>
--        o_param <= "00000000";
--    end case;
--    end process;
--end Behavioral;