LIBRARY ieee; 
USE ieee.std_logic_1164.all; 
USE ieee.std_logic_1164.all; 
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;

ENTITY AND1 IS
	PORT(a, b :IN std_logic;
			resolution: OUT std_logic);
	END AND1;
-- My AND 	
ARCHITECTURE func OF AND1 IS
	BEGIN 
		resolution<= a AND b;
	END func;
  
LIBRARY ieee; 
USE ieee.std_logic_1164.all; 
USE ieee.std_logic_1164.all; 
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all; 

ENTITY OR1 IS
	PORT(a, b : IN std_logic;
			resolution: OUT std_logic);
	END OR1;
-- My OR
ARCHITECTURE func OF OR1 IS
	BEGIN 
		resolution<= a OR b;
	END func;
  

LIBRARY ieee; 
USE ieee.std_logic_1164.all; 
USE ieee.std_logic_1164.all; 
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all; 
ENTITY NOR1 IS
	PORT(a, b : IN std_logic;
			resolution: OUT std_logic);
	END NOR1;
-- My NOR
ARCHITECTURE func OF NOR1 IS
	BEGIN
		resolution<= a NOR b;
	END func;


LIBRARY ieee; 
USE ieee.std_logic_1164.all; 
USE ieee.std_logic_1164.all; 
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all; 	
ENTITY XOR1 IS
  PORT(a,b : IN std_logic;
      resolution : OUT std_logic);
  END XOR1;
-- My XOR 
ARCHITECTURE func OF XOR1 IS
  BEGIN 
    resolution <= a XOR b;
 END func;

LIBRARY ieee; 
USE ieee.std_logic_1164.all; 
USE ieee.std_logic_1164.all; 
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;  

ENTITY adder IS
	PORT(cin, a,b : IN std_logic;
		cout, result	: OUT std_logic); -- Note: adder produces two output. One for CarryOut and one for the result of the operation
END adder;
  
--My adder. Calculates a CarryOut based on the CarryIn, and a result.  
ARCHITECTURE Structural OF adder IS
	BEGIN
		cout <= (b AND cin) OR (a AND cin) OR (a AND b);
		result <=  (a AND (NOT b) AND (NOT cin)) 
				OR ((NOT a) AND b AND (NOT cin)) 
				OR ((NOT a) AND (NOT b) AND cin)
				OR (a AND b AND cin);
	
END Structural;
  
LIBRARY ieee; 
USE ieee.std_logic_1164.all; 
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all; 
ENTITY mux2 IS
  PORT(a, inverse: IN std_logic;
      resolution 		:	OUT std_logic);
END mux2;
-- My MUX2. Inverts the input if so desired.
ARCHITECTURE archMux2 OF mux2 IS
  	BEGIN
		PROCESS(a, inverse)
		BEGIN
			IF inverse = '0' THEN
				resolution <= a;
			ELSE
				resolution <= NOT a;
			END IF;
		END PROCESS;
	END archMux2;

LIBRARY ieee; 
USE ieee.std_logic_1164.all; 
USE ieee.std_logic_1164.all; 
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;        
ENTITY ALU1 IS
	PORT (a, b, Ainvert, Binvert, cin:IN std_logic;
        operation: IN std_logic_vector(1 downto 0);
			cout, result	: OUT std_logic
       );
END ALU1;
  
--My ALU for 1 bit. Essentially does 5 desired operations and depending on the operation, it produces the desired output.
ARCHITECTURE archAl OF ALU1 IS

	COMPONENT adder
		PORT(a,b, cin: IN std_logic;
				cout,result: OUT std_logic);
		END COMPONENT;
	
	COMPONENT AND1
		PORT(a, b :IN std_logic;
			resolution: OUT std_logic);
		END COMPONENT;
	
	COMPONENT OR1
		PORT(a, b : IN std_logic;
			resolution: OUT std_logic);
		END COMPONENT;
  
   COMPONENT mux2
		PORT( a, inverse : IN std_logic;
    			resolution 	:	OUT std_logic);
		END COMPONENT;
  
   COMPONENT XOR1
		PORT(a,b : IN std_logic;
        resolution : OUT std_logic);
		END COMPONENT;

	--Intermediary signals for the port maps in order to pass the result to the desired output.
	SIGNAL resultAand, resultBand: std_logic;
	SIGNAL resultAadd, resultBadd: std_logic;
	SIGNAL resultAnd : std_logic;
	SIGNAL resultOr : std_logic;
	SIGNAL resultAdd : std_logic;
	SIGNAL AdderCout : std_logic;
	SIGNAL resultXor : std_logic;
	
   BEGIN --ARCHITECTURE BEGIN
	
    andA :  mux2 PORT MAP(a, Ainvert, resultAand);
    andB: mux2 PORT MAP(b, Binvert, resultBand);
		resolutionAnd: AND1 PORT MAP (resultAand, resultBand, resultAnd); 
		
	 addA: mux2 PORT MAP(a, Ainvert, resultAadd);
    addB: mux2 PORT MAP(b, Binvert, resultBadd);
		resolutionOr: OR1 PORT MAP (a, b, resultOr);

		resolutionAdd: adder PORT MAP(a, b, cin, AdderCout, resultAdd);
		
		resolutionXor: XOR1 PORT MAP (a,b, resultXor);
	 
  PROCESS(operation, a, Ainvert,b, cin, Binvert) is
  BEGIN --PROCESS BEGIN
	IF operation = "00" THEN
		result <= resultAnd;
	ELSIF operation = "01" THEN
		result <= resultOr;
	ELSIF operation = "10" THEN
		result <= resultAdd;
		cout <= AdderCout;
  ELSIF operation = "11" THEN
		result <= resultXor;
	END IF;
	
  END PROCESS;
END archAl;

    
LIBRARY ieee; 
USE ieee.std_logic_1164.all; 
USE ieee.std_logic_1164.all; 
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all; 

ENTITY alu16 IS
    PORT (a ,b : IN STD_LOGIC_VECTOR(15 downto 0);
          operationCode : IN std_logic_vector(2 downto 0);
          result	: OUT STD_LOGIC_vector(15 downto 0)); 
END alu16;
    
 
ARCHITECTURE archA16 OF alu16 IS
  COMPONENT alu1 
		PORT(a,b, Ainvert, Binvert, cin : IN std_logic;
        operation : IN std_logic_vector(1 downto 0);
			cout, result : OUT std_logic );
	END COMPONENT;
	
	--Intermediary signals for the port maps in order to pass the result to the desired output.
	SIGNAL operation : std_logic_vector(1 downto 0);
	SIGNAL  Ainvert : std_logic;
	SIGNAL Binvert : std_logic;
	SIGNAL cin: std_logic;
	SIGNAL cout : std_logic_vector(15 downto 0);
	SIGNAL resultALU1 : std_logic_vector(15 downto 0);
	SIGNAL cinForJump : std_logic_vector(15 downto 0);
  
  BEGIN 
    PROCESS(operationCode) is
      BEGIN 
      
         IF operationCode =  "000" THEN  	-- and
        	 operation <= "00";
				Ainvert <= '0';
				Binvert <= '0';
  				cin <= '0';
         ELSIF operationCode = "001" THEN -- or
          operation <= "01";
				Ainvert <= '0';
				Binvert <= '0';
  				cin <= '0';  
         ELSIF operationCode = "010" THEN -- sub. By inverting b we get the desired sub operation.
          operation <= "11";
				Ainvert <= '0';
				Binvert <= '1';
  				cin <= '1';
         ELSIF operationCode =  "011" THEN  -- xor
          operation <= "11";
				Ainvert <= '0';
				Binvert <= '0';
  				cin <= '0';
         ELSIF operationCode = "100" THEN -- add
          operation <= "10";
  				Ainvert <= '0';
    			Binvert <= '0';
  				cin <= '0';
         ELSIF operationCode = "101" THEN  -- nor. By inverting a,b we get the desired nor operation.
          operation <= "00";
				Ainvert <= '1';
				Binvert <= '1';
  				cin <= '0';
         ELSIF operationCode = "110" THEN  --irrelevant
         ELSIF operationCode = "111" THEN  -- irrelevant 

			END IF;		
      END PROCESS;
      
		
		--  8 μεταβλητές θέλουμε για port map της alu1
		-- Δεν βάζουμε την πρώτη φορα στην λούπα γιατί το πρώτο cin είναι μοναδικό και βοηθάει στην αναγνωσιμότητα.
      A1: alu1 PORT MAP(a(0), b(0), Ainvert, Binvert, cin, operation, cout(0), resultALU1(0));	
			result(0) <= resultALU1(0);
			cinForJump(0) <= cout(0);
		             

      -- εδώ να ξεκινάει η λούπα 15 φορές
		  G1: for i in 1 to 15 generate 
				ALUs: alu1 port map ( a(i), b(i), Ainvert, Binvert, cinForJump(i-1), operation, cout(i), resultALU1(i)); 
				result(i) <= resultALU1(i);
				cinForJump(i) <= cout(i);
			end generate; 

END archA16;