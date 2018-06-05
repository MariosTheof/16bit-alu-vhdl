LIBRARY ieee; 
USE ieee.std_logic_1164.all; 

USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;

ENTITY ALU1 IS
	PORT (a,b,ainversert,binversert, cin:IN std_logic;
        operation: IN std_logic;
			cout, result	: OUT std_logic
       );
END ALU1;
  

ARCHITECTURE archAl OF ALU1 IS

	COMPONENT adder
		PORT(a,b, cin: IN std_logic;
				cout,resolution: OUT std_logic);
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
    			resolution 	:	OUT std_logic
    );
  END COMPONENT;
  
  COMPONENT XOR1
  	PORT(a,b : IN std_logic;
        resolution : OUT std_logic
        );
  END COMPONENT;

   SIGNAL cout: std_logic;
   BEGIN --ARCHITECTURE BEGIN
	andA:  mux2 PORT MAP(a, ainverse, resolution);
    andB: mux2 PORT MAP(b, binverse, resolution);
	 resolutionAnd: AND1 PORT MAP (andA, andB, resolution);
	  addA: mux2 PORT MAP(a, ainverse, resolution);
    addB: mux2 PORT MAP(b, binverse, resolution);
		resolutionOr: OR1 PORT MAP (a, b, resolution);

		resolutionAdd: adder PORT MAP(ainverse, binverse, cin, cout, resolution);
		
    resolutionXor: XOR1 PORT MAP (a,b, resolution);
  PROCESS(operation, a, ainverse, resolution, b, cin,cout, BINVERSE) is
  BEGIN --PROCESS BEGIN
	IF operation = "00" THEN
		result<=resolutionAnd;
	ELSIF operation = "01" THEN
		
		result<=resolutionOr;
	ELSIF operation = "10" THEN
		
		result<=resolutionAdd;
		
  ELSIF operation ="11" THEN
  
		result<=resolutionAXor;
	END IF;
	
  END PROCESS;
END archAl;

    