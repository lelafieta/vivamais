import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/app_entity.dart';
import '../../../../config/theme/color_palette.dart';
import '../../../../core/resources/app_icons.dart';
import '../../../account/presentation/views/account_view.dart';
import '../../../feed/presentation/views/feed_view.dart';
import '../../../home/presentation/views/home_view.dart';
import '../../../messages/presentation/views/message_view.dart';
import '../../../tickets/presentation/views/ticket_view.dart';
import '../cubit/viva_mais_cubit.dart';
import '../cubit/viva_mais_state.dart';

class VivaMaisView extends StatefulWidget {
  const VivaMaisView({super.key});

  @override
  State<VivaMaisView> createState() => _VivaMaisViewState();
}

class _VivaMaisViewState extends State<VivaMaisView> {
  List<Widget> _widgets = [
    FeedView(),
    MessageView(),
    HomeView(),
    TicketView(),
    AccountView(),
  ];

  int _currentIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<VivaMaisCubit, VivaMaisState>(
        builder: (context, state) {
          if (state is VivaMaisLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            );
          } else if (state is VivaMaisStarted) {
            AppEntity.currentUser = state.currentUser;
            AppEntity.uid = state.currentUser.uid;
            return _widgets[_currentIndex];
          }
          return _widgets[_currentIndex];
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true,
        showUnselectedLabels: true,
        unselectedItemColor: AppColors.lightGrey,
        unselectedIconTheme: IconThemeData(
          color: AppColors.grey,
        ),
        selectedLabelStyle: TextStyle(
          color: AppColors.primaryColor,
        ),
        unselectedLabelStyle: TextStyle(
          color: AppColors.primaryColor,
        ),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AppIcons.feed,
              color: AppColors.grey,
            ),
            label: 'Feed',
            tooltip: "Feed",
            activeIcon: SvgPicture.asset(
              AppIcons.feed,
              color: AppColors.primaryColor,
            ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AppIcons.message,
              color: AppColors.grey,
            ),
            label: 'Mensagem',
            tooltip: "Mensagem",
            activeIcon: SvgPicture.asset(
              AppIcons.message,
              color: AppColors.primaryColor,
            ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AppIcons.home,
              color: AppColors.grey,
            ),
            label: 'Home',
            tooltip: "Home",
            activeIcon: SvgPicture.asset(
              AppIcons.home,
              color: AppColors.primaryColor,
            ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AppIcons.ticket,
              color: AppColors.grey,
            ),
            label: 'Ticket',
            tooltip: "Ticket",
            activeIcon: SvgPicture.asset(
              AppIcons.ticket,
              color: AppColors.primaryColor,
            ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AppIcons.user2,
              color: AppColors.grey,
            ),
            label: 'Conta',
            tooltip: "Conta",
            activeIcon: SvgPicture.asset(
              AppIcons.user2,
              color: AppColors.primaryColor,
            ),
          ),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: AppColors.primaryColor,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
