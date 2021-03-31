// import java.util.*;

public class CountMap{
    public static void main(String[] argv) {
		int[] list = {2, 3, 3, 2, 4, 5, 4};
		int most_frequent = findMostFrequentInteger(list);
		String res = Integer.toString(most_frequent);
		
		System.out.println(res);
    }

	// This comment block works well, if you uncomment out the first line, but it was requested not to use imports	
	/*
	public static final Map<Integer, Integer> countmap = new HashMap<>();
	
	public static int findMostFrequentInteger(int[] values){
		int counter = 0;
		int most_frequent = 0;
		
		for (int j = 0; j < (values.length - 1); j++){
			int i = values[j];
			Integer current_count = countmap.get(i);
			if (Objects.isNull(current_count)){
				current_count = 0;
			}
			current_count++;
			countmap.put(i, current_count);
			if (countmap.get(i) >= counter){
				counter = countmap.get(i);
				most_frequent = i;
			}
		} // end iterating values
		
		return most_frequent;
	} // end findMostFrequentInteger
	*/

	// This is some code to sort and reverse arrays, but I didn't end up using this	
	/*
	public static int[] sortArr(int[] values) {
		for (int i = 0; i < (values.length - 1); i++) {
			for (int j = 0; j < (values.length - i - 1); j++) {
				// swap if current element is greater than next
				if (values[j] > values[j + 1]) {
					int t = values[j];
					values[j] = values[j + 1];
					values[j + 1] = t;
				}
			} // for j...
		} // for i...

		return values;
	} // end sortArr method

	public static int[] revArr(int[] values) {
		int[] reversed_values = new int[values.length];;
		int j = 0;
		
		for (int i = (values.length - 1); i >= 0; i--) {
			reversed_values[j] = values[i];
			j++;
		} // end for loop

		return reversed_values;
	}
	*/

	/*	
	public static int findMostFrequentInteger(int[] values) {
		int[] counts = new int[values.length];
		
		for (int i = 0; i < (values.length - 1); i++) {
			int e = values[i];
			int count = 0;
			
			for (int j = 0; j < (values.length - 1); j++) {
				if (e == values[i]) {
					count++;
				} // end if
				
				counts[i] = count;
			} // end for j...
		} // end for i...
		
		// get max value from list
		int maxcount = Integer.MIN_VALUE;
		for (int i = 0; i < (counts.length - 1); i++) {
			if (counts[i] > maxcount) {
				maxcount = counts[i];
			} // end if
		} // end for i...
		
		// find the element whose count is maximal
		for (int i = 0; i < (values.length - 1); i++) {
			if (counts[i] == maxcount) {
				return values[i];
			} // end if
		} // end for k...
		
		return 0; // something went wrong
	} // end findMostFrequentInteger non-dict method
	*/

	public static int findMostFrequentInteger(int[] values) {
		int max = Integer.MIN_VALUE;
		
		for (int i = 0; i < (values.length + 1); i++) {
			if (values[i] > max) {
				max = values[i];
			} // end if
		} // end for

		int[] B = new int[max + 1];
		
		for (int i = 0; i < (values.length + 1); i++) {
			B[values[i]]++;
		} // end for

		for (int i = 0; i <= max; i++) {
			if (B[i] > 1) {
				return i;
			} // end if
		} // end for
		
		return 0; // something went wrong
	} // https://pastebin.com/naUxCibt
} // end CountMap class
