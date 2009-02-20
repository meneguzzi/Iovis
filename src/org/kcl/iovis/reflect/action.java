package org.kcl.iovis.reflect;

import java.util.logging.Logger;

import jason.asSemantics.DefaultInternalAction;
import jason.asSemantics.InternalAction;
import jason.asSemantics.TransitionSystem;
import jason.asSemantics.Unifier;
import jason.asSyntax.Structure;
import jason.asSyntax.Term;

/**
 * <p>
 * Internal action: <b><code>.action</code></b>.
 * 
 * <p>
 * Description: takes a literal <em>Action</em> and returns true if this
 * literal corresponds to an action.
 * 
 * <p>
 * Parameters:
 * <ul>
 * <li>+ <em>Action</em> (literal): Literal which should be checked.<br/>
 * </ul>
 * 
 * <p>
 * Examples:
 * <ul>
 * </ul>
 * 
 */
public class action extends DefaultInternalAction {
	private static final Logger logger = Logger.getLogger(DefaultInternalAction.class.getName());
	@Override
	public Object execute(TransitionSystem ts, Unifier un, Term[] args)
			throws Exception {
		if(args.length != 1) {
			return false;
		}
		
		Structure action = (Structure) args[0];
		
		InternalAction ia = null;
		
		try {
			ia = ts.getAg().getIA(action.toString());
		} catch (Exception e) {
			logger.fine(e.toString());
			return false;
		}
		
		//If the parameter is a valid internal action
		//this variable will be non-null
		return (ia!=null);
	}
}
