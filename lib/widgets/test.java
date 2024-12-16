import java.util.Scanner;

public class test {
    public static void main(String[] args) {

        Scanner sc = new Scanner(System.in);

        int n = sc.nextInt();

        int[] N = new int[n + 1];

        sc.close();

        for (int i = 0; i < N.length; i++) {
            N[i] = i;
        }

        long count = 1;
        long start_index = 1;
        long end_idnex = 1;
        long sum = 1;

        while (end_idnex != n) {
            if (sum == n) {
                end_idnex++;
                count++;
                sum += end_idnex;
            } else if (sum > n) {
                sum -= start_index;
                start_index++;

            } else if (sum < n) {
                end_idnex++;
                sum += end_idnex;

            }
        }

        System.out.println(count);
    }
}
