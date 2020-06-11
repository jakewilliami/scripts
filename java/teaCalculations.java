// This convesion calculator is for 11 pt garamond font (see jakewilliami/tex-macros for why)
// run using `java teaCalculations.java <int> <conversion from> <conversion to>`
// see the post which inspired this: https://tex.stackexchange.com/a/8337/181375

import java.util.Scanner;
import java.util.*;

//all measurements factor from [unit] to pts
public class MainConversions{
    
    public static final Map<String, Double> units = new HashMap<>();
    
    private static double conversionRatio(String from, String to) {
        return units.get(to) / units.get(from);
    }
    
    public static void main(String[] args) {
        
        //pt to pt
        units.put("pt", 1.00);
        //pt to mm
        units.put("mm", 2.84526);
        //pt to cm
        units.put("cm", 28.45274);
        units.put("ex", 4.93845);
        units.put("em", 10.95);
        units.put("bp", 1.00374);
        units.put("dd", 1.07);
        units.put("pc", 12.0);
        units.put("in", 72.26999);
        
        double size = Double.parseDouble(args[0]);
        String from = args[1];
        String to = args[2];
        double convertedSize = size * conversionRatio(to, from);
        
        String out = convertedSize + " " + to;
        System.out.println(out);
        
//       if (args.length != 3){
//           throw new RuntimeException("Script only supports exactly three arguments");
//       }
    }
}
