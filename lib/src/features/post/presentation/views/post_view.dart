import 'package:animate_do/animate_do.dart';
import 'package:vivamais/src/config/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../../../config/theme/color_palette.dart';
import '../../../../core/resources/app_icons.dart';
import '../../../../core/resources/app_images.dart';
import '../../../../core/resources/app_svg.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_values.dart';

class PostView extends StatelessWidget {
  const PostView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeInUp(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(
              "Criar um Post",
              //style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(AppMargin.m16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FormBuilderTextField(
                    name: 'hospital',
                    decoration: const InputDecoration(
                      hintText: 'Hospital',
                    ),
                    obscureText: true,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  SizedBox(
                    height: AppSize.s15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: FormBuilderTextField(
                          name: 'mes',
                          decoration: const InputDecoration(
                            hintText: 'Mês',
                            suffixIcon: Icon(Icons.calendar_month),
                          ),
                          obscureText: true,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                          ]),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: FormBuilderTextField(
                          name: 'hora',
                          decoration: const InputDecoration(
                            hintText: 'Hora',
                            suffixIcon: Icon(Icons.schedule_sharp),
                          ),
                          obscureText: true,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                          ]),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: AppSize.s15,
                  ),
                  FormBuilderTextField(
                    name: 'Arquivo',
                    decoration: const InputDecoration(
                      hintText: 'Arquivo',
                      border: InputBorder.none,
                    ),
                    obscureText: true,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  SizedBox(
                    height: AppSize.s15,
                  ),
                  FormBuilderTextField(
                    name: 'hospital',
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Uma descrição',
                      border: OutlineInputBorder(),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  SizedBox(
                    height: AppSize.s15,
                  ),
                  FormBuilderTextField(
                    name: 'Grupo Sanguíneo',
                    decoration: const InputDecoration(
                      hintText: 'Grupo Sanguíneo',
                      suffixIcon: Icon(FontAwesomeIcons.tint),
                      suffixIconColor: AppColors.primaryColor,
                    ),
                    obscureText: true,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            margin: EdgeInsets.all(AppMargin.m16),
            child: ElevatedButton(
              onPressed: () {},
              child: Text("Pedido de Doador"),
            ),
          ),
        ),
      ),
    );
  }
}
