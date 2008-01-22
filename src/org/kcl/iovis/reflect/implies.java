package org.kcl.iovis.reflect;

import java.io.StringReader;

import jason.asSemantics.DefaultInternalAction;
import jason.asSemantics.TransitionSystem;
import jason.asSemantics.Unifier;
import jason.asSyntax.LogicalFormula;
import jason.asSyntax.StringTerm;
import jason.asSyntax.Term;
import jason.asSyntax.parser.as2j;

/**
<p>Internal action: <b><code>.implies</code></b>.

<p>Description: takes a logical expression <em>Expression</em> and tries to 
 unify it with a predicate <em>Predicate</em> from a norm, thus indicating 
 whether or not a certain expression of the agents beliefs implies a certain
 norm.

<p>Parameters:<ul>
<li>+ <em>Expression</em> (string): the expression which should imply 
 <em>Predicate</em>.<br/>
<li>+- <em>Predicate</em> (string): the predicate which should be implied
  by <em>Expression</em>.<br/>
</ul>

<p>Examples:<ul>
</ul>

*/
public class implies extends DefaultInternalAction {

	@Override
	public Object execute(TransitionSystem ts, Unifier un, Term[] args)
			throws Exception {
		StringTerm planString = (StringTerm) args[0];
		
		Term implies = args[1];
		
		StringReader reader = new StringReader(planString.getString());
		as2j parser = new as2j(reader);
		
		LogicalFormula formula = (LogicalFormula) parser.log_expr();
		
		formula.logicalConsequence(ts.getAg(), un);
		
		//double check everything here.
		
		return true;
	}
}
