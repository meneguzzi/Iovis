package org.kcl.iovis.reflect;

import java.io.StringReader;
import java.util.List;
import java.util.logging.Logger;

import jason.asSemantics.DefaultInternalAction;
import jason.asSemantics.TransitionSystem;
import jason.asSemantics.Unifier;
import jason.asSyntax.BodyLiteral;
import jason.asSyntax.ListTerm;
import jason.asSyntax.ListTermImpl;
import jason.asSyntax.Literal;
import jason.asSyntax.Plan;
import jason.asSyntax.StringTerm;
import jason.asSyntax.Term;
import jason.asSyntax.parser.as2j;

/**
<p>Internal action: <b><code>.plan_steps</code></b>.

<p>Description: takes a plan <em>Plan</em> and unifies its plan steps as 
 a list of literals with <em>Steps</em>.

<p>Parameters:<ul>
<li>+ <em>Plan</em> (string): Plan from which the steps should be unified.<br/>
<li>+- <em>Steps</em> (list): The steps from <em>Plan</em>.<br/>
</ul>

<p>Examples:<ul>
</ul>

*/
public class plan_steps extends DefaultInternalAction {
	
	public static final Logger logger = Logger.getLogger(DefaultInternalAction.class.getName());

	@Override
	public Object execute(TransitionSystem ts, Unifier un, Term[] args)
			throws Exception {
		StringTerm planString = (StringTerm) args[0];
		Term steps = args[1];
		
		StringReader reader = new StringReader(planString.getString());
		as2j parser = new as2j(reader);
		Plan plan = parser.plan();
		List<BodyLiteral> body = plan.getBody();
		
		ListTerm stepListTerm = new ListTermImpl();
		
		for (BodyLiteral bodyLiteral : body) {
			if(bodyLiteral.getLiteralFormula() == null)
				continue;
			Literal literal = (Literal) bodyLiteral.getLiteralFormula().clone();
			stepListTerm.add(literal);
		}
		
		if(un.unifies(steps, stepListTerm)) {
			steps.apply(un);
		} else {
			return false;
		}
		
		return true;
	}
}
