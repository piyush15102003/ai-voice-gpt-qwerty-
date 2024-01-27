import 'package:ai_voiceee/featuers_list.dart';
import 'package:ai_voiceee/openAi_services.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:http/http.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final speechToText = SpeechToText();
  final flutterTts = FlutterTts();
  String lastWords = '';
  final OpenAIService openaiservice = OpenAIService();
  String? generatedContent;
  String? generatedImageURL;
  int start = 200;
  int delay = 200;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSpeechToText();
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  Future<void> systemSpeak(String content) async{
    await flutterTts.speak(content);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BounceInDown(child: Text('Qwerty')),
        centerTitle: true,
        leading: Icon(Icons.menu),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //assistant image
            ZoomIn(
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      height: 120,
                      width: 120,
                      margin: const EdgeInsets.only(top: 4),
                      decoration: const BoxDecoration(
                        color: Colors.white70,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Container(
                    height: 123,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/images/virtualAssistant.png'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // chat bubble
            FadeInLeft(
              child: Visibility(
                visible : generatedImageURL == null,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 10,
                  ),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 40).copyWith(top: 30),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                      ),
                      borderRadius:
                          BorderRadius.circular(20).copyWith(topLeft: Radius.zero)),
                  child:  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      generatedContent == null
                          ? 'Good Morning, what task can i do for you?'
                          : generatedContent!,
                      style: TextStyle(
                        fontFamily: 'Cera Pro',
                        color: Colors.white,
                        fontSize: generatedContent == null ? 25 : 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            //suggestion box
            if (generatedImageURL != null )Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image.network(generatedImageURL!),
            ),
            SlideInLeft(
              child: Visibility(
                visible: generatedContent == null && generatedImageURL == null,
                child: Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(top: 10, left: 12),
                  alignment: Alignment.centerLeft,
                  child: const Text('Here are few commands',
                      style: TextStyle(
                        fontFamily: 'Cera Pro',
                        color: Color.fromRGBO(59, 100, 103, 1.0),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      )),
                ),
              ),
            ),
            // suggestion list
            Visibility(
              visible: generatedContent == null && generatedImageURL == null,
              child: Column(
                children: [
                  SlideInLeft(
                    delay: Duration(milliseconds: start) ,
                    child: const  FeatureBox(
                      color: Color.fromRGBO(132, 184, 236, 1.0),
                      headerText: 'ChatGPT',
                      descriptionText:
                          'A smarter way to stay organized and informed with ChatGPT',
                    ),
                  ),
                  SlideInLeft(
                    delay: Duration(milliseconds: start + delay),
                    child: const  FeatureBox(
                      color: Color.fromRGBO(197, 211, 243, 1.0),
                      headerText: 'Dall-E',
                      descriptionText:
                          'Get inspired and stay creative with your personal assistant Dall-E',
                    ),
                  ),
                  SlideInLeft(
                    delay: Duration(milliseconds: start+delay+delay),
                    child: const  FeatureBox(
                      color: Color.fromRGBO(114, 225, 231, 1.0),
                      headerText: 'Smart Voice Assistant',
                      descriptionText:
                          'Get the best of both world with a voice assistant powered Dall-E and ChAtGPT',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: ZoomIn(
        delay: Duration(milliseconds: start + 3*delay ),
        child: FloatingActionButton(
          onPressed: () async {
            if (await speechToText.hasPermission && speechToText.isNotListening) {
              await startListening();
            } else if (speechToText.isListening) {
             final speech = await openaiservice.isArtPromptAPI(lastWords);
             if(speech.contains('https')){
               generatedImageURL = speech;
               generatedContent = null;
               setState(() {});
             }
             else{
               generatedImageURL = null;
               generatedContent = speech;
               await systemSpeak(speech);
               setState(() {});
             }
              await stopListening();
            } else {
              initSpeechToText();
            }
          },
          backgroundColor: const  Color.fromRGBO(132, 184, 236, 1.0),
          child: Icon(
              speechToText.isListening ? Icons.stop : Icons.mic),
        ),
      ),
    );
  }
}
