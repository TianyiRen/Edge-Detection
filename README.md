Name: Tianyi Ren
UNI: tr2400


Walkthrough 1:
	Threshold: thresh = 0.5
	Number of dilations/erosions: k=10

Challenge 1:
	a. Set threshold = 0.5 for all three images: threshold_list = [0.5, 0.5, 0.5]
		Generated labeled images by using bwlabel function with 4 connectivity
	b. Used red dot to represent the center and green line to represent the orientation
	c. Used minimum moment of inertia and roundness for comparison. Combination criteria: 
		if E and Roundness satisfy 0.95<E_d<1.05 and 0.95<R_d<1.05, where E_d and R_d are from object model database. 

Walkthrough 2:
	Threshold for sobel: thresh = 0.13
	Threshold for canny: thresh = 0.25

Challenge 2:
	a. Used edge function with "canny" method and threshold = 0.05
	b. The range of theta is from -89 degree to 90 degree, and the range of rho is from -l to l, where l is the length of the image's diagonal. 
		Voting scheme: voting for every bin works, since there are enough points on the edge.
	c. Hough threshold: 0.23 for three images
	    How to find peaks: First we set a window. Then we loop until the peak value is below the threshold. If a peak which is above the threshold is found, set the value of theta and rho, and draw a line with the pair of theta and rho. If there is more than one peak found, we choose the first one. Then we set all the Hough values within the window to zero and continue in loop.
	d. Hough threshold: 0.23 for three images
	    How to determine the end points: 
	    First, we find all points on the edges that satisfy: 
	    0.998*rho < x*sin(theta)+y*cos(theta) < 1.002*rho;
	    Second, find the smallest x value and largest x value as the two endpoints of a line. There are very likely that we find more than two endpoints since the we have a range of rho, then we can use the mean value of the x values;
	     Third, if the smallest x value and largest x value are very close to each other(for example, the distance is smaller than 5, which is used in the code), we compute the smallest and largest y value.


