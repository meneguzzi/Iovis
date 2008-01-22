package org.kcl.iovis.reflect;

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

import java.io.StringReader;
import java.util.List;

/**
<p>Internal action: <b><code>.plan_consequences</code></b>.

<p>Description: takes a plan <em>Plan</em> and unifies its declarative 
 consequences event with <em>Consequences</em>.

<p>Parameters:<ul>
<li>+ <em>Plan</em> (string): Plan from which the consequences should be 
 unified.<br/>
<li>+- <em>Consequences</em> (string): The declarative consequences from 
 <em>Plan</em>.<br/>
</ul>

<p>Examples:<ul>
</ul>

*/
public class plan_consequences extends DefaultInternalAction {

	@Override
	public Object execute(TransitionSystem ts, Unifier un, Term[] args)
			throws Exception {
		StringTerm planString = (StringTerm) args[0];
		
		Term conseqTerm = args[1];
		
		StringReader reader = new StringReader(planString.getString());
		as2j parser = new as2j(reader);
		Plan plan = parser.plan();
		
		//Then we try to extract belief the effects from the plan body
		List<BodyLiteral> body = plan.getBody();
		ListTerm consequences = new ListTermImpl();
		
		for (BodyLiteral literal : body) {
			Literal lit = null;
			if(literal.getType() == BodyLiteral.BodyType.delBel) {
				// XXX We were having problems with the variables using this method of instantiation
				//proposition = new PropositionImpl(false, literal.getLiteralFormula().toString());
				// XXX So we changed it to this mode
				lit = new Literal(literal.getLiteralFormula());
				lit.setNegated(Literal.LNeg);
			} else if(literal.getType() == BodyLiteral.BodyType.addBel) {
				// XXX We were having problems with the variables using this method of instantiation
				//proposition = new PropositionImpl(true, literal.getLiteralFormula().toString());
				// XXX So we changed it to this mode
				lit = new Literal(literal.getLiteralFormula());
			}
			
			//If proposition is null, this is a part of the plan we can't cope, 
			//so we ignore it. Adding only valid effects
			if(lit != null) {
				consequences.add(lit);
			}
		}
		
		if(un.unifies(conseqTerm, consequences)) {
			conseqTerm.apply(un);
		} else {
			return false;
		}
		
		return true;
	}
}
