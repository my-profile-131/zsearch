import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zsearch/src/search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _searchEngines = [
    {'name': 'Google', 'icon': '🔍'},
    {'name': 'Brave', 'icon': '🦁'},
    {'name': 'DuckDuckGo', 'icon': '🦆'},
    {'name': 'Bing', 'icon': '🦋'},
  ];

  final List<Map<String, dynamic>> _shortcuts = [
    {
      'name': 'Youtube',
      'icon': Icons.ondemand_video_outlined,
      'color': Colors.red,
    },
    {'name': 'Github', 'icon': Icons.code, 'color': Colors.black},
    {'name': 'Linkidin', 'icon': Icons.business, 'color': Colors.blue},
    {'name': 'ChatGPT', 'icon': Icons.psychology, 'color': Colors.black},
    {'name': 'Wikipedia', 'icon': Icons.menu_book, 'color': Colors.black},
  ];

  late Map<String, String> _selectedEngine;

  @override
  void initState() {
    super.initState();
    _selectedEngine = _searchEngines[0];
  }

  void _searchWithQuery(String query) {
    if(query.trim().isNotEmpty){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchPage(searchQuery: query, selectedEngine: _selectedEngine,)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: .symmetric(horizontal: 30, vertical: 50),
          child: Column(
            children: [
              Text(
                "My Browser",
                style: TextStyle(
                  fontSize: 46,
                  fontWeight: .bold,
                  color: Colors.blueAccent,
                ),
              ),

              SizedBox(height: 35),

              Material(
                elevation: 1,
                borderRadius: .circular(30),

                //searchbar
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search Anything...",

                    //dropdown for multiple browser
                    prefixIcon: Container(
                      padding: .fromLTRB(15, 0, 0, 0),
                      constraints: BoxConstraints(maxWidth: 80),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Map<String, String>>(
                          value: _selectedEngine,
                          icon: Icon(Icons.arrow_drop_down, size: 16),
                          alignment: .center,
                          selectedItemBuilder: (BuildContext context) {
                            return _searchEngines.map<Widget>((engine) {
                              return Center(
                                child: Text(
                                  engine['icon']!,
                                  style: TextStyle(fontSize: 20),
                                ),
                              );
                            }).toList();
                          },

                          items: _searchEngines.map((engine) {
                            return DropdownMenuItem(
                              value: engine,
                              child: Center(
                                child: Text(
                                  engine['icon']!,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            );
                          }).toList(),

                          onChanged: (value) =>
                              setState(() => _selectedEngine = value!),
                        ),
                      ),
                    ),

                    suffixIcon: IconButton(
                      onPressed: () => _searchWithQuery(_searchController.text),
                      icon: Icon(CupertinoIcons.search),
                    ),

                    border: OutlineInputBorder(
                      borderRadius: .circular(30),
                      borderSide: .none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: .symmetric(vertical: 18),
                  ),
                ),
              ),
              SizedBox(height: 50),


              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                itemCount: _shortcuts.length,
                itemBuilder: (context, index) {
                  final shortcut = _shortcuts[index];
                  return Material(
                    color: Colors.white,
                    borderRadius: .circular(16),
                    elevation: 1,
                    child: InkWell(
                      borderRadius: .circular(16),
                      onTap: () => _searchWithQuery(shortcut['name']),
                      child: Padding(
                        padding: .all(8),

                        child: Column(
                          mainAxisAlignment: .center,
                          children: [
                            Container(
                              padding: .all(12),
                              decoration: BoxDecoration(
                                color: shortcut['color'].withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                shortcut['icon'],
                                color: shortcut['color'],
                                size: 28,
                              ),
                            ),
                            SizedBox(height: 12,),

                            Flexible(
                              child: Text(
                                shortcut['name'],
                                textAlign: .center,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: .w600,
                                ),
                                overflow: .ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
