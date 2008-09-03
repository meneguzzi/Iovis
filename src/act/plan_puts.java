package act;

import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import jason.asSemantics.DefaultInternalAction;
import jason.asSemantics.InternalAction;
import jason.asSemantics.TransitionSystem;
import jason.asSemantics.Unifier;
import jason.asSyntax.StringTerm;
import jason.asSyntax.StringTermImpl;
import jason.asSyntax.Term;
import jason.asSyntax.VarTerm;
/**
 * A variant of puts for plan creation, which escapes quotation marks.
 * @author meneguzz
 *
 */
public class plan_puts extends DefaultInternalAction {
	
	private static InternalAction singleton = null;

	public static InternalAction create() {
		if (singleton == null)
			singleton = new plan_puts();
		return singleton;
	}

	Pattern regex = Pattern.compile("#\\{\\p{Upper}\\p{Alnum}*\\}");

	@Override
	public Object execute(TransitionSystem ts, Unifier un, Term[] args)
			throws Exception {
		if (!args[0].isString()) {
			return false;
		}

		StringBuffer sb = new StringBuffer();
		for (Term term : args) {
			if (!term.isString()) {
				continue;
			}
			StringTerm st = (StringTerm) term;
			Matcher matcher = regex.matcher(st.getString());

			ArrayList<Term> alVariables = new ArrayList<Term>();

			while (matcher.find()) {
				/*
				 * System.out.println("I found the text \""+matcher.group()+ "\"
				 * starting at index "+matcher.start()+ " and ending at index
				 * "+matcher.end());
				 */
				String sVar = matcher.group();
				sVar = sVar.substring(2, sVar.length() - 1);
				alVariables.add(un.get(sVar));
			}

			matcher.reset();

			while (matcher.find()) {
				Term t = alVariables.remove(0);
				matcher.appendReplacement(sb, t.toString());
			}
			matcher.appendTail(sb);
		}

		if (args[args.length - 1].isVar()) {
			StringTerm stRes = new StringTermImpl(escapeStrings(sb.toString()));
			VarTerm var = (VarTerm) args[args.length - 1];
			if (un.unifies(stRes, var)) {
				return var.apply(un);
			} else {
				return false;
			}
		} else {
			ts.getLogger().info(sb.toString());
			return true;
		}
	}
	
	protected String escapeStrings(String planString) {
		//System.out.println("Escaping string: "+planString);
		int index = planString.indexOf("\"");
		while (index != -1) {
			planString = planString.substring(0, index) + "\\\""
					+ planString.substring(index + 1);
			index = planString.indexOf("\"", index + 2);
		}
		//System.out.println("Escaped string: "+planString);
		return planString;
	}
}
