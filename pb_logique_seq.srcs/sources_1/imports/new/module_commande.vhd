--  module_commande.vhd
--  D. Dalle  30 avril 2019, 16 janv 2020, 23 avril 2020
--  module qui permet de r�unir toutes les commandes (problematique circuit sequentiels)
--  recues des boutons, avec conditionnement, et des interrupteurs

-- 23 avril 2020 elimination constante mode_seq_bouton: std_logic := '0'

LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity module_commande IS
generic (nbtn : integer := 4;  mode_simulation: std_logic := '0');
    PORT (
          clk              : in  std_logic;
          o_reset          : out  std_logic; 
          i_btn            : in  std_logic_vector (nbtn-1 downto 0); -- signaux directs des boutons
          i_sw             : in  std_logic_vector (3 downto 0);      -- signaux directs des interrupteurs
          o_btn_cd         : out std_logic_vector (nbtn-1 downto 0); -- signaux conditionn�s 
          o_selection_fct  :  out std_logic_vector(1 downto 0);
          o_selection_par  :  out std_logic_vector(1 downto 0)
          );
end module_commande;

ARCHITECTURE BEHAVIOR OF module_commande IS
    type type_etat is (E0, E1, E2, E3) ;
    signal etat_courant, nouvel_etat : type_etat;
    signal o_etat : std_logic_vector(1 downto 0);
component conditionne_btn_v7 is
generic (nbtn : integer := nbtn;  mode_simul: std_logic := '0');
    port (
         CLK          : in std_logic;         -- devrait etre de l ordre de 50 Mhz
         i_btn        : in    std_logic_vector (nbtn-1 downto 0);
         --
         o_btn_db     : out    std_logic_vector (nbtn-1 downto 0);
         o_strobe_btn : out    std_logic_vector (nbtn-1 downto 0)
         );
end component;


    signal d_strobe_btn :    std_logic_vector (nbtn-1 downto 0);
    signal d_btn_cd     :    std_logic_vector (nbtn-1 downto 0); 
    signal d_reset      :    std_logic;
   -- signal btn      :    std_logic_vector (nbtn-1 downto 0);
   signal BTN : std_logic_vector (nbtn-1 downto 0);
BEGIN 
   BTN <= d_strobe_btn;
                  
 inst_cond_btn:  conditionne_btn_v7
    generic map (nbtn => nbtn, mode_simul => mode_simulation)
    port map(
        clk           => clk,
        i_btn         => i_btn,
        o_btn_db      => d_btn_cd,
        o_strobe_btn  => d_strobe_btn  
         );
 
 sequet: process(clk)
     begin
        if rising_edge(clk) then
--            if d_reset = '1' then
--                etat_courant <= E0;
--            else
            --etat_courant <= nouvel_etat;
            o_reset <= d_reset;
             etat_courant <= nouvel_etat ;
        end if;
      --  end if;
     end process;
 decod_entree : process(BTN, etat_courant)
    begin
    nouvel_etat <= etat_courant;
    case etat_courant is 
        when E0=>
            if (BTN = "0001") then
                nouvel_etat <= E1;
            elsif (BTN = "0010") then 
                nouvel_etat <= E3;
            
            end if;
        when E1=> 
            if (BTN = "0001") then
                nouvel_etat <= E2;
            elsif (BTN = "0010") then 
                nouvel_etat <= E0;
           
            end if;
        when E2=>
            if (BTN = "0001") then
                nouvel_etat <= E3;
            elsif (BTN = "0010") then 
                nouvel_etat <= E1;
               
            end if;
        when E3=>
            if (BTN = "0001") then
                nouvel_etat <= E0;
            elsif (BTN = "0010") then 
                nouvel_etat <= E2;
               
            end if;
        when others =>
        -- tous les cas ont �t� test�
    end case;
    end process; 
   
   
output_assignment : process(etat_courant)
    begin
    case etat_courant is 
        when E0=>
            
            o_etat <= "00";
        when E1=>
            o_etat <= "01";
        when E2=>
            o_etat <= "10";
        when E3=>
            o_etat <= "11";
        when others =>
        -- tous les cas ont �t� test�
    end case;
    end process; 
   o_btn_cd        <= d_btn_cd;
   o_selection_par <= i_sw(1 downto 0); -- mode de selection du parametre par sw
   o_selection_fct <= o_etat; -- mode de selection de la fonction par sw
   d_reset         <= i_btn(3);         -- pas de contionnement particulier sur reset

END BEHAVIOR;
