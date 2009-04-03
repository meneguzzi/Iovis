package org.kcl.iovis.reflect;

import jason.asSemantics.DefaultInternalAction;
import jason.asSemantics.TransitionSystem;
import jason.asSemantics.Unifier;
import jason.asSyntax.ListTerm;
import jason.asSyntax.Term;

/**
<p>Internal action: <b><code>.contains</code></b>.

<p>Description: takes a list <em>List</em> and an element <em>Element</em>
  and returns whether or not the <em>List</em> contains the <em>Element</em>.

<p>Parameters:<ul>
<li>+ <em>List</em> (list): list to be checked for <em>Element</em>.<br/>
<li>+ <em>Element</em> (term): element to be checked in the <em>List</em>.<br/>
</ul>

<p>Examples:<ul>
</ul>

*/
public class contains extends DefaultInternalAction {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public Object execute(TransitionSystem ts, Unifier un, Term[] args)
			throws Exception {
		if(args.length != 2) {
			return false;
		}
		
		ListTerm list = (ListTerm) args[0];
		Term element = args[1];
		//Iterate over the list to see if it contains the specified
		//element
		for(Term t : list) {
			if(!t.isVar() && un.unifies(t, element)) {
				return true;
			}
		}
		
		return false;
	}
}
