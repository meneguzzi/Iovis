package org.kcl.iovis.reflect;

import java.io.StringReader;

import jason.asSemantics.DefaultInternalAction;
import jason.asSemantics.TransitionSystem;
import jason.asSemantics.Unifier;
import jason.asSyntax.Plan;
import jason.asSyntax.StringTerm;
import jason.asSyntax.StringTermImpl;
import jason.asSyntax.Term;
import jason.asSyntax.parser.as2j;

/**
<p>Internal action: <b><code>.plan_context</code></b>.

<p>Description: takes a plan <em>Plan</em> and unifies its context with <em>Context</em>.

<p>Parameters:<ul>
<li>+ <em>Plan</em> (string): Plan from which the context should be unified.<br/>
<li>+- <em>Context</em> (string): The context from <em>Plan</em>.<br/>
</ul>

<p>Examples:<ul>
</ul>

*/
public class plan_context extends DefaultInternalAction {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public Object execute(TransitionSystem ts, Unifier un, Term[] args)
			throws Exception {
		StringTerm planString = (StringTerm) args[0];
		
		Term context = args[1];
		
		StringReader reader = new StringReader(planString.getString());
		as2j parser = new as2j(reader);
		Plan plan = parser.plan();
		
		StringTerm stringContext = new StringTermImpl(plan.getContext().toString());
		
		if(un.unifies(context, stringContext)) {
			context.apply(un);
		} else {
			return false;
		}
		
		return true;
	}
}
