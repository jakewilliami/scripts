import java.util.*;

public class CountMap{
    public static void main(String[] argv) {
		Object[] example1 = new Object[2];
		example1[0] = String("Te Aro Street");
		example1[1] = Double(2.0);
		Object[] example2 = new Object[2];
		example2[0] = String("Adam's Terrace");
		example2[1] = Double(0.2);
		Object[] example3 = new Object[2];
		example3[0] = String("Adam's Terrace");
		example3[1] = Double(0.1);
		Object[] example4 = new Object[2];
		example4[0] = String("Adam's Terrace");
		example4[1] = Double(0.3);
		Object[] example5 = new Object[2];
		example5[0] = String("Fairlie Terrace");
		example5[1] = Double(1.2);
		
		Object[] examplePath = {example1, example2, example3, example4, example5};

		LinkedHashMap<String,Double> shortestPath = collapseMap(examplePath);

		for (Map.Entry p: shortestPath.entrySet()) {
			System.out.println(p.getKey() + ": " + p.getValue() + "km");
		}

		double totalDistance = 0.0;
		for (double f: shortestPath.values()) {
			totalDistance += f;
		}

		System.out.println("\nTotal distance: " + totalDistance + "km");
    } // end main

	public static LinkedHashMap<String,Double> collapseMap(Object[] path) {
		LinkedHashMap<String,Double> collapsedHashMap = new LinkedHashMap<String,Double>();
		
		for (int i = 0; i < (path.length + 1); i++) {
			String streetName = path[i][1];
			double currentstreetLength = path[i][2];
			Double newStreetLength = collapsedHashMap.get(streetName);
			
			if (newStreetLength == null) {
				newStreetLength = currentStreetLength;
			} else {
				newStreetLength += currentStreetLength;
			}

			collapsedHashMap.put(streetName, newStreetLength);
		}

		return collapsedHashMap;
		
	} // end displayPath method
} // end CountMap class
