package me.chyxion.xls;

import java.io.FileOutputStream;
import java.util.Scanner;

/**
 * @version 0.0.1
 * @since 0.0.1
 * @author Shaun Chyxion <br />
 * chyxion@163.com <br />
 * Oct 24, 2014 2:07:51 PM
 */
public class TestDriver {


	public static void main(String[] args) throws Exception {
		StringBuilder html = new StringBuilder();
		Scanner s = new Scanner(Scanner.class.getResourceAsStream("/sample.html"), "utf-8");
		while (s.hasNext()) {
			html.append(s.nextLine());
		}
		s.close();
		FileOutputStream fout = new FileOutputStream("d:\\data.xls");
		fout.write(TableToXls.process(html));
		fout.close();
	}
}
