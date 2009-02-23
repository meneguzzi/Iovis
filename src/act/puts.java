package act;

import jason.asSemantics.DefaultInternalAction;
import jason.asSemantics.InternalAction;
import jason.asSemantics.TransitionSystem;
import jason.asSemantics.Unifier;
import jason.asSyntax.ASSyntax;
import jason.asSyntax.StringTerm;
import jason.asSyntax.StringTermImpl;
import jason.asSyntax.Term;
import jason.asSyntax.parser.ParseException;

import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * <p>
 * Internal action: <b><code>.puts</code></b>.
 * 
 * <p>
 * Description: used for printing messages to the console where the system is
 * running, or unifying the message to a variable parameter. It receives one
 * string parameter, containing escaped variable names that are replaced by
 * their bindings in the current intention's unifier. Terms are made ground
 * according to the current unifying function before being printed out. No new
 * line is printed after the parameters. In this version a user can also 
 * include any Jason expression (logical or arithmetic) that will be replaced
 * by it's evaluated value.
 * 
 * <p>
 * The precise format and output device of the message is defined by the Java
 * logging configuration as defined in the <code>logging.properties</code>
 * file in the project directory.
 * 
 * <p>
 * Parameters:
 * <ul>
 * 
 * <li>+message (string): the string to be printed out.</li>
 * <li>-output (any variable [optional]): the variable to print the processed
 * result.</li>
 * 
 * </ul>
 * 
 * <p>
 * Example:
 * <ul>
 * 
 * <li> <code>.puts("Testing variable #{A}")</code>: prints out to the
 * console the supplied string replacing #{A} with the value of variable A.</li>
 * 
 * </ul>
 * 
 * @see act.puts
 * @author Felipe Meneguzzi (http://www.meneguzzi.eu/felipe)
 * 
 */

@SuppressWarnings("serial")
public class puts extends DefaultInternalAction {

	private static InternalAction singleton = null;

	public static InternalAction create() {
		if (singleton == null)
			singleton = new puts();
		return singleton;
	}

	//Pattern regex = Pattern.compile("#\\{\\p{Upper}\\p{Alnum}*\\}");
	Pattern regex = Pattern.compile("#\\{\\p{ASCII}+\\}");

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
				try {
					Term t = ASSyntax.parseTerm(sVar);
					t.apply(un);
					alVariables.add(t);
				} catch (ParseException pe) {
					// TODO: handle exception
					// TODO: Decide whether or not we should ignore the exception and print the call instead
					// Right now, if I get a parse error from ASSyntax, I just print the original escaped
					// sequence, so a user can see that his/her expression was problematic
					alVariables.add(new StringTermImpl("#{"+sVar+"}"));
				}
				
			}

			matcher.reset();

			while (matcher.find()) {
				Term t = alVariables.remove(0);
				matcher.appendReplacement(sb, t.toString());
			}
			matcher.appendTail(sb);
		}

		if (args[args.length - 1].isVar()) {
			StringTerm stRes = new StringTermImpl(sb.toString());
			return un.unifies(stRes, args[args.length - 1]);
		} else {
			ts.getLogger().info(sb.toString());
			return true;
		}
	}
}
