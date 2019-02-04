package routines;
import java.util.Arrays;

public class EditShotLogs {
	public static String matchNames(String name1) {
    
    	String[] def = {"Barea, Jose Juan", "Hardaway Jr., Tim", 
    			"Aminu, Al-Farouq", "Nene", "Mbah a Moute, Luc",
    			"Hayes, Charles", "Lucas III, John", "Taylor, Jeff",
    			"Rice Jr., Glen", "Datome, Gigi", "McAdoo, James Michael"};
    	String[] stats = {"J.J. Barea", "Tim Hardaway", 
    			"Al-Farouq Aminu", "Nene Hilario", "Luc Mbah",
    			"Chuck Hayes", "John Lucas", "Jeffery Taylor",
    			"Glen Rice", "Luigi Datome", "James Michael"};
    	
    	String[] results = {"barea jj", "hardaway tim", 
    			"al-farouq aminu", "nene hilario", "luc mbah",
    			"chuck hayes", "john lucas", "jeffery taylor",
    			"glen rice", "datome luigi", "james mcadoo michael"};
    	
    	if (Arrays.asList(def).contains(name1) || Arrays.asList(stats).contains(name1)) {
    		for (int i = 0; i < def.length; i++) {
    			if (name1.equals(def[i]) || name1.equals(stats[i])) {
    				return results[i];
    			}
    		}  
    	}
    	
    	String[] names1 = name1.replaceAll("[^a-zA-Z ]", "").toLowerCase().split("\\s+");
    	Arrays.sort(names1);
    	
    	String nuova = "";
    	for (int i = 0; i < names1.length; i++) {
    		nuova += names1[i];
    		nuova += " ";
    	}
    	
    	nuova = nuova.trim();
    	return nuova;
    	
    }
	
	public static String shotClock(String shot, Float shotAvg) {
    	String shot2 = shot.trim();
    	if (shot2.equals("")) {
    		return String.valueOf(shotAvg);
   	    } else {
    		return shot2;
    	}
    }
	
	public static String percentage(String percentage, Float ts) {
		String percentage2 = percentage.trim();
    	if (percentage2.equals("")) {
    		return String.valueOf(ts);
   	    } else {
    		return percentage2;
    	}
	}
}
