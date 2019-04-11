package tdh.util;

import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.nio.charset.Charset;

public class GetFileFromUrl {
	
	

	public static boolean saveUrlAs(String Url, String fileName) {
		boolean b = false;
		try {
			URL url = new URL(Url);
			HttpURLConnection connection = (HttpURLConnection) url
					.openConnection();
			DataInputStream in = new DataInputStream(
					connection.getInputStream());
			DataOutputStream out = new DataOutputStream(new FileOutputStream(
					fileName));
			byte[] buffer = new byte[4096];
			int count = 0;
			while ((count = in.read(buffer)) > 0) {
				out.write(buffer, 0, count);
			}
			out.close();
			in.close();
			if (buffer.length < 1024)
				b = false;
			b = true;
		} catch (Exception e) {
			e.printStackTrace();
			b = false;
		}
		return b;
	}

	public static String getDocumentAt(String Url) {
		StringBuffer document = new StringBuffer();
		try {
			URL url = new URL(Url);
			URLConnection conn = url.openConnection();
			BufferedReader reader = new BufferedReader(new InputStreamReader(
					conn.getInputStream(), Charset.forName("UTF-8")));
			String line = null;
			while ((line = reader.readLine()) != null) {
				document.append(line + "\n");
			}
			reader.close();
		} catch (MalformedURLException e) {
			System.out.println("Unable to connect to URL: " + Url);
		} catch (IOException e) {
			System.out.println("IOException when connecting to URL: " + Url);
		}
		return document.toString();
	}
}