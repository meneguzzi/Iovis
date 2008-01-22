package org.kcl.iovis.reflect;

import jason.asSemantics.DefaultInternalAction;
import jason.asSemantics.TransitionSystem;
import jason.asSemantics.Unifier;
import jason.asSyntax.Plan;
import jason.asSyntax.StringTerm;
import jason.asSyntax.Term;
import jason.asSyntax.Trigger;
import jason.asSyntax.parser.as2j;

import java.io.StringReader;

/**
<p>Internal action: <b><code>.plan_trigger</code></b>.

<p>Description: takes a plan <em>Plan</em> and unifies its triggering event 
 with <em>Trigger</em>.

<p>Parameters:<ul>
<li>+ <em>Plan</em> (string): Plan from which the triggering event should be 
 unified.<br/>
<li>+- <em>Trigger</em> (string): The triggering event from <em>Plan</em>.<br/>
</ul>

<p>Examples:<ul>
</ul>

*/
public class plan_trigger extends DefaultInternalAction {

	@Override
	public Object execute(TransitionSystem ts, Unifier un, Term[] args)
			throws Exception {
		StringTerm planString = (StringTerm) args[0];
		Term triggerTerm = args[1];
		
		StringReader reader = new StringReader(planString.getString());
		as2j parser = new as2j(reader);
		Plan plan = parser.plan();
		Trigger trigger = plan.getTriggerEvent();
		
		if(un.unifies(triggerTerm, trigger.getLiteral())) {
			triggerTerm.apply(un);
		} else {
			return false;
		}
		
		return true;
	}
}
