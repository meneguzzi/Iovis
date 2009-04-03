package org.kcl.iovis.reflect;

import jason.asSemantics.DefaultInternalAction;
import jason.asSemantics.TransitionSystem;
import jason.asSemantics.Unifier;
import jason.asSyntax.ListTerm;
import jason.asSyntax.ListTermImpl;
import jason.asSyntax.Plan;
import jason.asSyntax.PlanLibrary;
import jason.asSyntax.StringTerm;
import jason.asSyntax.StringTermImpl;
import jason.asSyntax.Term;

public class plan_library extends DefaultInternalAction {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public Object execute(TransitionSystem ts, Unifier un, Term[] args)
			throws Exception {
		if(args.length != 1) {
			return false;
		}
		
		Term tRes = args[0];
		
		PlanLibrary pl = ts.getAg().getPL();
		
		ListTerm plans = new ListTermImpl();
		
		for (Plan plan : pl) {
			StringTerm st = new StringTermImpl(plan.toASString());
			
			plans.add(st);
		}
		
		if(un.unifies(tRes, plans)) {
			tRes.apply(un);
		} else {
			return false;
		}
		
		return true;
	}
}
