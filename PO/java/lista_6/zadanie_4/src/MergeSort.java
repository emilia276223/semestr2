import java.util.Arrays;
import java.util.Random;

public class MergeSort<T extends Comparable<T>> extends Thread{
	T[] elements;
	private int priority;
	public MergeSort(T[] tab) {
		priority = 0;
//		System.out.println("new merge with size "+tab.length);
		elements = tab;
	}
	public MergeSort(T[] tab, int x) {
		priority = x;
//		System.out.println("new merge with size "+tab.length);
		elements = tab;
	}
	public void run() {
		if(elements.length <= 1) {
			return;
		}
		if(elements.length == 2){
			if (elements[0].compareTo(elements[1]) == 1) {
				T temp = elements[0];
				elements[0] = elements[1];
				elements[1] = temp;
			}
			return;
		}
		//new arrays that will be sorted
		int s = elements.length;
		int leftLength = s/2;
		int rightLength = s - leftLength;
		T[] elementsLeft = Arrays.copyOf(elements, leftLength);
		T[] elementsRight = Arrays.copyOfRange(elements, leftLength, leftLength + rightLength);

		//sorting the rest
		var mergeLeft = new MergeSort<T>(elementsLeft, priority + 1);
		var mergeRight = new MergeSort<T>(elementsRight, priority + 1);
		mergeRight.setPriority(priority + 1);
		mergeLeft.setPriority(priority + 1);
		mergeRight.start();
		mergeLeft.start();
//		System.out.println("Waiting for merged both halfs (merge size " + elements.length + ")");
		try {
			mergeRight.join();
		} catch (InterruptedException e) {
			throw new RuntimeException(e);
		}
		try {
			mergeLeft.join();
		} catch (InterruptedException e) {
			throw new RuntimeException(e);
		}
//		while(!mergeLeft.isFinished() || !mergeRight.isFinished());

		//merging the arrays
//		System.out.println("Now merging arrays of " + leftLength + " and " + rightLength + " elements.");
		int iteratorLeft = 0;
		int iteratorRight = 0;
		for(int i = 0; i < elements.length; i++){
			if(iteratorLeft == leftLength){
				elements[i] = mergeRight.elements[iteratorRight];
				iteratorRight++;
			}
			else if (iteratorRight == rightLength){
				elements[i] = mergeLeft.elements[iteratorLeft];
				iteratorLeft++;
			}
			else if(mergeLeft.elements[iteratorLeft].compareTo(mergeRight.elements[iteratorRight]) < 1){
				elements[i] = mergeLeft.elements[iteratorLeft];
				iteratorLeft++;
			}
			else{
				elements[i] = mergeRight.elements[iteratorRight];
				iteratorRight++;
			}
		}
//		System.out.println("Merge (size" + elements.length + ") finished!");
	}

	public static void main(String[] args) throws InterruptedException {
		Integer[] tab1 = {1,3,5,6,7,8,9,3,6,4,2,5,8,5,8,9,5,3,5,7,5};
		var merge1 = new MergeSort<Integer> (tab1);
		Double[] tab2 = {3.14, 5.0, 23.456, 2.7, 0.07, 42.69};
		var merge2 =new MergeSort (tab2);
		merge1.start();
		merge2.start();
		merge1.join();
		merge2.join();
		tab1 = merge1.elements;
		System.out.println(Arrays.toString(tab1));
		var tab2new = merge2.elements;
		System.out.println(Arrays.toString(tab2new));

		//test na większych rzeczach:
		Random rand = new Random();
		Integer[] bigArray = new Integer[1000];
		for(int i = 0; i < 1000; i++){
			bigArray[i] = rand.nextInt();
		}
		var bigMerge = new MergeSort<Integer>(bigArray);
		bigMerge.start();
		bigMerge.join();
		System.out.println(Arrays.toString(bigMerge.elements));
	}
}
