import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SearchPage extends StatefulWidget {
  final String searchQuery;
  final Map<String, String> selectedEngine;

  const SearchPage({super.key, required this.searchQuery, required this.selectedEngine});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _searchController = TextEditingController();
  late Map<String, String> _currentEngine;
  late final WebViewController _webViewController;
  bool _isLoading = true;


  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text:  widget.searchQuery);
    _currentEngine = widget.selectedEngine;


    //webview controller setup
    _webViewController = WebViewController()
    ..setJavaScriptMode(.unrestricted)
    ..setBackgroundColor(Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (String url) {
          setState(() {
            _isLoading = true;
          });
        },
        onPageFinished: (String url){
          setState(() {
            _isLoading = false;
          });
          _hideEngineSearchHearder();
          //this is for i don't want to show heading of any search engine
        },
      ),
    );
    _loadSearchQuery(widget.searchQuery);

  }

  String _getSearchUrl(String engineName, String query){
    final encodeQuery = Uri.encodeComponent(query);
    switch (engineName){
      case 'Google':
        return 'https://www.google.com/search?q=$encodeQuery';
      case 'Brave':
        return 'https://search.brave.com/search?q=$encodeQuery';
      case 'DuckDuckGo':
        return 'https://html.duckduckgo.com/search?q=$encodeQuery';
      case 'Bing':
        return 'https://www.bing.com/search?q=$encodeQuery';
      default:
        return 'https://www.google.com/search?q=$encodeQuery';
    }
  }


  void _loadSearchQuery(String query){
    if(query.trim().isNotEmpty){
      final url = _getSearchUrl(_currentEngine['name']!, query);
      _webViewController.loadRequest(Uri.parse(url));
    }
  }

  //i will provide this js in description and pin comment
  void _hideEngineSearchHearder() {
    _webViewController.runJavaScript(
        '''
      (function() {
        // Yeh selectors Google, Bing, DuckDuckGo aur Brave ke search-header aur logos ko target karte hain
        const selectorsToHide = [
          '#header', 'header', '.header', 
          '#tsf', '#searchform', 'form[action="/search"]', 'div[role="search"]', // Google
          '#header_wrapper', '.header__search', '#search_form', // DuckDuckGo
          '#search-box', '.search-form', '.header-form', // Brave
          '#b_header', '#sb_form', '.b_logo', '.b_searchboxForm' // Bing
        ];

        selectorsToHide.forEach(selector => {
          const elements = document.querySelectorAll(selector);
          elements.forEach(el => {
            if (el) {
              el.style.setProperty('display', 'none', 'important');
            }
          });
        });

        // Kuch sites (jaise Google mobile view) me top bar ka space khali na dikhe isliye body ka padding reset karte hain
        document.body.style.paddingTop = '0px';
        document.body.style.marginTop = '0px';
      })();
    ''');
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black12,
        leading: IconButton(onPressed: ()=> Navigator.pop(context), icon: Icon(CupertinoIcons.back, color: Colors.black87,)),

        title: Container(
          height: 46,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: .circular(30),
          ),
          child: TextField(
            controller: _searchController,
            onSubmitted: (value) => _loadSearchQuery(value),
            decoration: InputDecoration(
              hintText: "Search Anything",
              prefixIcon: Padding(padding: .only(left: 14, right: 8, top: 10, bottom: 10),
              child: Text(
                _currentEngine['icon']!,
                style: TextStyle(fontSize: 18),
              ),
              ),

              suffixIcon: IconButton(onPressed: ()=> _loadSearchQuery(_searchController.text), icon: Icon(CupertinoIcons.search, color: Colors.blueAccent,)),
              border: InputBorder.none,
              contentPadding: .symmetric(vertical: 10),
            ),
          ),
        ),
      ),


      body: Stack(
        children: [

          WebViewWidget(controller: _webViewController),

          if(_isLoading)
            LinearProgressIndicator(
              color: Colors.blueAccent,
              backgroundColor: Colors.transparent,
              minHeight: 4,
            )

        ],
      ),


    );
  }
}
