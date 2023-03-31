import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:new_passwords_manager/common/unfocus.dart';

import '../common/fireabase_services.dart';
import '../model/account.dart';
import '../pages/acc_templates_page.dart';
import '../pages/login_page.dart';
import '../widgets/custom_search_bar.dart';
import '../widgets/item_tile.dart';
import '../common/common.dart';
import '../provider.dart';
import 'added_account_page.dart';

class MyHomePage extends ConsumerStatefulWidget {
  static const String routeName = '/';
  const MyHomePage({super.key});

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  late final TextEditingController _searchController;
  void logOut(context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    await firebaseAuth.signOut();
    Navigator.pop(context);

    Navigator.pushReplacementNamed(context, LoginPage.routeName);
  }

  @override
  void initState() {
    _searchController = TextEditingController();
    _searchController.addListener(() {
      ref
          .read(searchProvider.notifier)
          .update((state) => _searchController.text);
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appBarName = ref.read(profileNameProvider);
    final mediaQuery = MediaQuery.of(context);
    final deviceWidth = mediaQuery.size.width;
    final imageUrl = ref.watch(imageAvatarProvider);
    final appBar = AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: Padding(
        padding:
            EdgeInsets.only(left: deviceWidth * 0.03, top: deviceWidth * 0.023),
        child: ClipRRect(
          
            borderRadius: BorderRadius.circular(deviceWidth * 0.3),
            child: imageUrl.isNotEmpty?  Image.network(
                 imageUrl,
                  fit: BoxFit.fitHeight,
                )
              :const Icon(Icons.person)),
      ),
      leadingWidth: deviceWidth * 0.2,
      title: Column(children: [
        SizedBox(
          width: deviceWidth * 0.6,
        ),
        Text("Welcome Back",
            style: TextStyle(
                color: Colors.greenAccent.withOpacity(0.6), shadows: const [])),
        Text(
          appBarName,
          style: const TextStyle(color: Colors.black),
        ),
      ]),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: deviceWidth * 0.02),
          child: CircleAvatar(
            radius: deviceWidth * 0.065,
            backgroundColor: Colors.greenAccent.withOpacity(0.4),
            child: PopupMenuButton(
              position: PopupMenuPosition.under,
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'log out',
                  child: Row(
                    children: const [
                      Icon(Icons.logout),
                      Text("Log Out"),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                if (value == 'log out') {
                  logOut(context);
                }
              },
              child: const Icon(Icons.more_vert),
            ),
          ),
        )
      ],
      toolbarHeight: deviceWidth * 0.20,
    );

    final deviceHeight = mediaQuery.size.height -
        mediaQuery.padding.bottom -
        appBar.preferredSize.height;

    void toAccTemplate() {
      Navigator.pushNamed(context, AccountTemplatesPage.routeName, arguments: {
        'height': deviceHeight,
        'width': deviceWidth,
      });
    }

    return Scaffold(
      appBar: appBar,
      extendBody: true,
      body: Unfocus(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: deviceHeight * 0.05,
              ),
              ref.watch(cloudItemsProvider).when(
                    data: (accounts) => accounts.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Lottie.asset('assets/videos/empty.zip'),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: deviceWidth * 0.045,
                                    vertical: deviceWidth * 0.01),
                                child: const Text(
                                  "No Account Added Yet !!",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              CustomSearchBar(
                                  icon: const Icon(Icons.search),
                                  label: "Search",
                                  controller: _searchController),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: deviceWidth * 0.045,
                                    vertical: deviceWidth * 0.01),
                                child: const Text(
                                  "Recently Added ",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: deviceHeight * 0.75,
                                child: ListView.builder(
                                  padding: EdgeInsets.only(
                                      bottom: deviceHeight * 0.08),
                                  itemCount:
                                      filterAccountList(accounts, ref).length,
                                  itemBuilder: (context, index) {
                                    ref.watch(cloudItemsProvider);
                                    List<Account> accList =
                                        filterAccountList(accounts, ref);
                                    var acc = accList[index];
                                    return ItemTile(
                                      logo: acc.logo,
                                      title: acc.accountCompany,
                                      subtitle: acc.email,
                                      deviceHeight: deviceHeight,
                                      deviceWidth: deviceWidth,
                                      tilePressed: () {
                                        Navigator.pushNamed(
                                            context, AddedAccountPage.routeName,
                                            arguments: {'account': acc});
                                        ref
                                            .read(edittingProvider.notifier)
                                            .update((state) => acc);
                                      },
                                      deletePressed: () {
                                        FireBaseServices()
                                            .deletAccount(ref, acc.createdAt);
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                    error: (error, stackTrace) => Center(
                      child: Text(error.toString()),
                    ),
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toAccTemplate,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
