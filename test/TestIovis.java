import jason.asunit.TestAgent;

import org.junit.Before;
import org.junit.Test;

public class TestIovis {

	TestAgent ag;
	
	@Before
	public void setup() {
		ag = new TestAgent();
		
		ag.parseAScode(
				"{include(\"src/org/kcl/iovis/iovis.asl\")}" +
				"+create : true" +
				"   <- .create_agent(newAgent,\"src/org/kcl/iovis/normAgent.asl\");" +
				"      !print(\"Created agent\").");
	}
	
	@Test
	public void testActionObligation() {
		//Fist add the obligation
		ag.addBel("norm(print(X), nprint(X), obligation(.print(\"Printing obligation\")), [])[source(env)]");
		ag.assertEvt("+norm(print(X), nprint(X), obligation(.print(\"Printing obligation\")), [])[source(env)]",0);
		
		//Now we want to make sure that the agent actually believes the norm
		//ag.assert
	}
}
