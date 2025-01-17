// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:stormymart_v2/Core/Appbar/Presentation/appbar_ui_mobile.dart';
import 'package:stormymart_v2/Core/Footer/footer.dart';
import 'package:stormymart_v2/Screens%20&%20Features/Home/Presentation/home_build_body.dart';
import '../../../Core/Drawer/Presentation/category_drawer.dart';
import '../Bloc/home_bloc.dart';
import '../Bloc/home_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            drawer: coreDrawer(context),
            appBar: PreferredSize(
                preferredSize: const Size.fromHeight(65),
                child: coreAppBar(context, state)
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  homeBuildBody(context, state),

                  coreFooter(),
                ],
              ),
            ),
          );
        }
        ),
    );
  }
}
