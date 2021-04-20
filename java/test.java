double totalDistance = 0.0;
double roadLength = 0.0;
double tempLength = 0.0;

getTextOutputArea().setText("");

for (int i = 0; i < shortestPath.size(); i++) {
	double roadLengthRaw = shortestPath.get(i).length;
	String roadName = shortestPath.get(i).road.name;

	// if we aren't at the end of the path
	if ((i + 1) != shortestPath.size()) {
		String currentRoadName = shortestPath.get(i).road.name;
		String nextRoadName = shortestPath.get(i + 1).road.name;

		// while the current road is the same as the next road
		while (currentRoadName == nextRoadName) {
			// add the current road length to the next road name
			tempLength += roadLengthRaw;
			// increment counter
			i++;
			// update road names
			currentRoadName = shortestPath.get(i).road.name;
			nextRoadName = shortestPath.get(i + 1).road.name;
			// update road length for current path
			roadLengthRaw = shortestPath.get(i).length;
		}

		/* end of same-road path */
		// update road length
		// do we need tempLength?
		roadLength = tempLength + roadLengthRaw;
	} else { // we are at the final step of the path
		roadLength = roadLengthRaw;
	}

	// update total distance
	totalDistance += roadLength;

	// construct info string
	String infoString = toTitleCase(roadName) + ": " + roundToSF(roadLengthRaw, 3) + "km\n";

	// reset road length and remporary road length.
	roadLength = 0.0;
	tempLength = 0.0;

	// update info output
	getTextOutputArea().append(infoString);
} // end for loop

// print the total distance of the path found
getTextOutputArea().append("\nTotal distance = " + roundToSF(totalDistance, 3) + "km\n");


// ----------------------

