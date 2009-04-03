package org.kcl.iovis.reflect;

import jason.asSemantics.DefaultInternalAction;
import jason.asSemantics.TransitionSystem;
import jason.asSemantics.Unifier;
import jason.asSyntax.Plan;
import jason.asSyntax.StringTerm;
import jason.asSyntax.Term;
import jason.asSyntax.parser.as2j;

import java.io.StringReader;
/**
<p>Internal action: <b><code>.plan_label</code></b>.

<p>Description: takes a plan <em>Plan</em> and unifies its label event 
 with <em>Label</em>. Not to be confused with <em>.plan_label</em> from
 Jason's stdlib.

<p>Parameters:<ul>
<li>+ <em>Plan</em> (string): Plan from which the label should be 
 unified.<br/>
<li>+- <em>:abel</em> (string): The label from <em>Plan</em>.<br/>
</ul>

<p>Examples:<ul>
</ul>

*/
public class plan_label extends DefaultInternalAction {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public Object execute(TransitionSystem ts, Unifier un, Term[] args)
			throws Exception {
		StringTerm planString = (StringTerm) args[0];
		Term labelTerm = args[1];
		
		StringReader reader = new StringReader(planString.getString());
		as2j parser = new as2j(reader);
		Plan plan = parser.plan();
		Term label = plan.getLabel();
		
		if(un.unifies(labelTerm, label)) {
			labelTerm.apply(un);
		} else {
			return false;
		}
		
		return true;
	}
}
