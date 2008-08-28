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
<p>Internal action: <b><code>.puts</code></b>.

<p>Description: used for printing messages to the console where the system
is running, or unifying the message to a variable parameter. It receives one
string parameter, containing escaped variable names that are replaced by their
bindings in the current intention's unifier. Terms are made
ground according to the current unifying function before being printed
out. No new line is printed after the parameters.

<p> The precise format and output device of the message is defined
by the Java logging configuration as defined in the
<code>logging.properties</code> file in the project directory.

<p>Parameters:<ul>

<li>+message (string): the string to be printed out.</li>
<li>-output (any variable [optional]): the variable to print the 
                                       processed result.</li>

</ul>

<p>Example:<ul> 

<li> <code>.puts("Testing variable #{A}")</code>: prints out to the console the
supplied string replacing #{A} with the value of variable A.</li>

</ul>

@see act.puts
@author Felipe Meneguzzi (http://www.meneguzzi.eu/felipe)

*/

public class puts extends DefaultInternalAction {
	
	private static InternalAction singleton = null;
	public static InternalAction create() {
		if (singleton == null) 
			singleton = new puts();
		return singleton;
	}
	
	Pattern regex = Pattern.compile("#\\{\\p{Upper}\\p{Alnum}*\\}");
	
	@Override
	public Object execute(TransitionSystem ts, Unifier un, Term[] args)
			throws Exception {
		if(!args[0].isString()) {
			return false;
		}
		
		StringBuffer sb = new StringBuffer();
		for(Term term : args) {
			if(!term.isString()) {
				continue;
			}
			StringTerm st = (StringTerm) term;
			Matcher matcher = regex.matcher(st.getString());
			
			ArrayList<Term> alVariables = new ArrayList<Term>();
			
			while(matcher.find()) {
				/*System.out.println("I found the text \""+matcher.group()+
						   "\" starting at index "+matcher.start()+
						   " and ending at index "+matcher.end());*/
				String sVar = matcher.group();
				sVar = sVar.substring(2,sVar.length()-1);
				alVariables.add(un.get(sVar));
			}
			
			matcher.reset();
			
			while(matcher.find()) {
				Term t = alVariables.remove(0);
				matcher.appendReplacement(sb, t.toString());
			}
			matcher.appendTail(sb);
		}
		
		if(args[args.length-1].isVar()) {
			StringTerm stRes = new StringTermImpl(sb.toString());
			VarTerm var = (VarTerm) args[args.length-1];
			if(un.unifies(stRes, var)) {
				return var.apply(un);
			} else {
				return false;
			}
		} else {
			ts.getLogger().info(sb.toString());
			return true;
		}
	}
}
