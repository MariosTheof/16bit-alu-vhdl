LIBRARY ieee; 
USE ieee.std_logic_1164.all; 
USE ieee.std_logic_1164.all; 
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;

ENTITY AND1 IS
	PORT(a, b :IN std_logic;
			resolution: OUT std_logic);
	END AND1;
	
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
		cout, sum	: OUT std_logic);
END adder;
  

ARCHITECTURE Structural OF adder IS
	BEGIN
		cout <= (b AND cin) OR (a AND cin) OR (a AND b);
		sum <=  (a AND (NOT b) AND (NOT cin)) 
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
ENTITY ALU IS
	PORT (a, b, ainverse, binverse, cin:IN std_logic;
        operation: IN std_logic_vector(1 downto 0);
			cout, result	: OUT std_logic
       );
END ALU;
  

ARCHITECTURE archAl OF ALU IS

	COMPONENT adder
		PORT(a,b, cin: IN std_logic;
				cout,sum: OUT std_logic);
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

	SIGNAL resultAand, resultBand: std_logic;
	SIGNAL resultAadd, resultBadd: std_logic;
	SIGNAL resultAnd : std_logic;
	SIGNAL resultOr : std_logic;
	SIGNAL resultAdd : std_logic;
	SIGNAL resultXor : std_logic;
	
   BEGIN --ARCHITECTURE BEGIN
	
    andA :  mux2 PORT MAP(a, ainverse, resultAand);
    andB: mux2 PORT MAP(b, binverse, resultBand);
		resolutionAnd: AND1 PORT MAP (resultAand, resultBand, resultAnd);
		
	 addA: mux2 PORT MAP(a, ainverse, resultAadd);
    addB: mux2 PORT MAP(b, binverse, resultBadd);
		resolutionOr: OR1 PORT MAP (a, b, resultOr);

		resolutionAdd: adder PORT MAP(ainverse, binverse, cin, cout, resultAdd);
		
		resolutionXor: XOR1 PORT MAP (a,b, resultXor);
	 
  PROCESS(operation, a, ainverse,b, cin, binverse) is
  BEGIN --PROCESS BEGIN
	IF operation = "00" THEN
		result <= resultAnd;
	ELSIF operation = "01" THEN
		result <= resultOr;
	ELSIF operation = "10" THEN
		result <= resultAdd;
  ELSIF operation ="11" THEN
		result <= resultXor;
	END IF;
	
  END PROCESS;
END archAl;