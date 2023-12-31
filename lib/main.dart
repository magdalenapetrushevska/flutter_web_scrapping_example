import 'package:flutter/material.dart'; 
import 'package:html/parser.dart' as parser; 
import 'package:http/http.dart' as http; 

void main() => runApp(MaterialApp( 
	theme: ThemeData( 
	hintColor: Colors.purple, 
	scaffoldBackgroundColor: Colors.purple[100], 
	primaryColor: Colors.purple, 
	), 
	home: MyApp())); 

class MyApp extends StatefulWidget { 
const MyApp({Key? key}) : super(key: key); 

@override 
_MyAppState createState() => _MyAppState(); 
} 

class _MyAppState extends State<MyApp> { 
	
// Strings to store the extracted Article titles 
String result1 = 'Result 1'; 
String result2 = 'Result 2'; 
String result3 = 'Result 3'; 
	
// boolean to show CircularProgressIndication 
// while Web Scraping awaits 
bool isLoading = false; 

Future<List<String>> extractData() async { 
	
	// Getting the response from the targeted url 
	final response = 
		await http.Client().get(Uri.parse('http://crimemap.finki.ukim.mk/data/en')); 
	
		// Status Code 200 means response has been received successfully 
	if (response.statusCode == 200) { 
		
	// Getting the html document from the response 
	var document = parser.parse(response.body); 
	try { 
		
		var responseString1 = document 
			.getElementsByClassName('shto')[0]; 

		print(responseString1.text.trim()); 
		
		var responseString2 = document 
			.getElementsByClassName('datum')[0]; 

		print(responseString2.text.trim()); 
		
		var responseString3 = document 
			.getElementsByClassName('lat')[0]; 

		print(responseString3.text.trim()); 
		
		// Converting the extracted titles into 
		// string and returning a list of Strings 
		return [ 
		responseString1.text.trim(), 
		responseString2.text.trim(), 
		responseString3.text.trim() 
		]; 
	} catch (e) { 
		return ['', '', 'ERROR!']; 
	} 
	} else { 
	return ['', '', 'ERROR: ${response.statusCode}.']; 
	} 
} 

@override 
Widget build(BuildContext context) { 
	return Scaffold( 
	appBar: AppBar(title: Text('GeeksForGeeks')), 
	body: Padding( 
		padding: const EdgeInsets.all(16.0), 
		child: Center( 
			child: Column( 
		mainAxisAlignment: MainAxisAlignment.center, 
		children: [ 
			
			// if isLoading is true show loader 
			// else show Column of Texts 
			isLoading 
				? CircularProgressIndicator() 
				: Column( 
					children: [ 
					Text('Tip: $result1', 
						style: TextStyle( 
							fontSize: 20, fontWeight: FontWeight.bold)), 
					SizedBox( 
						height: MediaQuery.of(context).size.height * 0.05, 
					), 
					Text('Datum: $result2', 
						style: TextStyle( 
							fontSize: 20, fontWeight: FontWeight.bold)), 
					SizedBox( 
						height: MediaQuery.of(context).size.height * 0.05, 
					), 
					Text('G. shi.: $result3', 
						style: TextStyle( 
							fontSize: 20, fontWeight: FontWeight.bold)), 
					], 
				), 
			SizedBox(height: MediaQuery.of(context).size.height * 0.08), 
			MaterialButton( 
			onPressed: () async { 
				
			// Setting isLoading true to show the loader 
				setState(() { 
				isLoading = true; 
				}); 
				
				// Awaiting for web scraping function 
				// to return list of strings 
				final response = await extractData(); 
				
				// Setting the received strings to be 
				// displayed and making isLoading false 
				// to hide the loader 
				setState(() { 
				result1 = response[0]; 
				result2 = response[1]; 
				result3 = response[2]; 
				isLoading = false; 
				}); 
			}, 
			child: Text( 
				'Scrap Data', 
				style: TextStyle(color: Colors.white), 
			), 
			color: Colors.purple, 
			) 
		], 
		)), 
	), 
	); 
} 
} 
