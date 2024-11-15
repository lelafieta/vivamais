import 'package:animate_do/animate_do.dart';
import 'package:awesome_place_search/awesome_place_search.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../../../config/routes/routes.dart';
import '../../../../config/theme/color_palette.dart';
import '../../../../core/resources/app_icons.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_values.dart';
import '../../../blood/presentation/cubit/blood_cubit.dart';
import '../../../blood/presentation/cubit/blood_state.dart';

class CreateRequestView extends StatefulWidget {
  final String blood;
  final PredictionModel prediction;

  const CreateRequestView(
      {super.key, required this.blood, required this.prediction});

  @override
  State<CreateRequestView> createState() => _CreateRequestViewState();
}

class _CreateRequestViewState extends State<CreateRequestView> {
  String get apiKey => dotenv.env['ANDROID_GOOGLE_API_KEY'] ?? '';
  TextEditingController controller = TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();
  TextEditingController locationHospital = TextEditingController();
  TextEditingController blood = TextEditingController();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  PredictionModel? prediction;
  Widget bloodIcon = Icon(FontAwesomeIcons.tint);

  List<String> bloods = [
    "A+",
    "B+",
    "AB-",
    "A-",
    "O-",
    "AB+",
    "O+",
    "B-",
  ];

  void bloodSvg(String blood) {
    switch (blood) {
      case "A+":
        setState(() {
          bloodIcon = SvgPicture.asset(
            AppIcons.ap,
            width: 12,
            color: AppColors.primaryColor,
          );
        });
        break;

      case "B+":
        setState(() {
          bloodIcon = SvgPicture.asset(
            AppIcons.bp,
            width: 12,
            color: AppColors.primaryColor,
          );
        });
        break;
      case "AB-":
        setState(() {
          bloodIcon = SvgPicture.asset(
            AppIcons.abn,
            width: 12,
            color: AppColors.primaryColor,
          );
        });
        break;
      case "A-":
        setState(() {
          bloodIcon = SvgPicture.asset(
            AppIcons.an,
            width: 12,
            color: AppColors.primaryColor,
          );
        });
        break;
      case "O-":
        setState(() {
          bloodIcon = SvgPicture.asset(
            AppIcons.oN,
            width: 12,
            color: AppColors.primaryColor,
          );
        });
      case "AB+":
        setState(() {
          bloodIcon = SvgPicture.asset(
            AppIcons.ab,
            width: 12,
            color: AppColors.primaryColor,
          );
        });
      case "O+":
        setState(() {
          bloodIcon = SvgPicture.asset(
            AppIcons.op,
            width: 12,
            color: AppColors.primaryColor,
          );
        });
      case "B-":
        setState(() {
          bloodIcon = SvgPicture.asset(
            AppIcons.b,
            width: 12,
            color: AppColors.primaryColor,
          );
        });
      default:
        setState(() {
          bloodIcon = Icon(
            FontAwesomeIcons.tint,
            color: AppColors.primaryColor,
          );
        });
    }
  }

  Widget svgBlood(String blood) {
    switch (blood) {
      case "A+":
        return SvgPicture.asset(
          AppIcons.ap,
          color: AppColors.primaryColor,
        );

      case "B+":
        return SvgPicture.asset(
          AppIcons.bp,
          color: AppColors.primaryColor,
        );
      case "AB-":
        return SvgPicture.asset(
          AppIcons.abn,
          color: AppColors.primaryColor,
        );
      case "A-":
        return SvgPicture.asset(
          AppIcons.an,
          color: AppColors.primaryColor,
        );
      case "O-":
        return SvgPicture.asset(
          AppIcons.oN,
          color: AppColors.primaryColor,
        );
      case "AB+":
        return SvgPicture.asset(
          AppIcons.ab,
          color: AppColors.primaryColor,
        );
      case "O+":
        return SvgPicture.asset(
          AppIcons.op,
          color: AppColors.primaryColor,
        );
      case "B-":
        return SvgPicture.asset(
          AppIcons.b,
          color: AppColors.primaryColor,
        );
      default:
        return Icon(
          FontAwesomeIcons.tint,
          color: AppColors.primaryColor,
        );
    }
  }

  void _searchPlaces() {
    AwesomePlaceSearch(
      context: context,
      apiKey: apiKey,
      countries: ["ao"],
      errorText: "Ouve um erro, tente novamente mais tarde",
      hint: "Pesquise um hospital",
      dividerItemColor: Colors.grey.withOpacity(.5),
      dividerItemWidth: .5,
      elevation: 5,
      indicatorColor: Colors.blue,
      modalBorderRadius: 50.0,
      onTap: (value) async {
        final result = await value;

        setState(() {
          locationHospital.text = result.description!;
          prediction = result;
        });
      },
    ).show();
  }

  @override
  void initState() {
    prediction = widget.prediction;
    locationHospital.text = widget.prediction.description!;
    blood.text = widget.blood;
    bloodSvg(blood.text);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeInUp(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(
              "Criar um Pedido",
              //style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(AppMargin.m16),
              child: FormBuilder(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: FormBuilderTextField(
                        controller: locationHospital,
                        onTap: () {
                          _searchPlaces();
                        },
                        readOnly: true,
                        name: "search",
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.only(left: AppSize.s10),
                          hintText: 'Selecionar Hospital',
                          suffixIcon: Icon(Icons.location_on_rounded),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: AppSize.s15,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: FormBuilderDateTimePicker(
                            name: 'date',
                            inputType: InputType
                                .date, // Define o tipo apenas como data
                            format: DateFormat("dd/MM"),
                            decoration: const InputDecoration(
                              hintText: 'date',
                              suffixIcon: Icon(Icons.calendar_month),
                            ),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(
                                  errorText: "Data inválida"),
                            ]),
                            firstDate: DateTime(DateTime.now().year, 1, 1),
                            lastDate: DateTime(DateTime.now().year, 12, 31),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: FormBuilderDateTimePicker(
                            name: 'time',
                            inputType: InputType
                                .time, // Define que o input é do tipo hora
                            format: DateFormat(
                                "HH:mm"), // Formato de hora de 24 horas

                            decoration: const InputDecoration(
                              hintText: 'Hora',
                              suffixIcon: Icon(Icons.calendar_month),
                            ),

                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(
                                  errorText: "Hora inválida"),
                            ]),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: AppSize.s15,
                    ),
                    FormBuilderFilePicker(
                      name: "file",
                      decoration: InputDecoration(labelText: "Aquivo"),
                      maxFiles: null,
                      previewImages: true,
                      onChanged: (val) => print(val),
                      typeSelectors: [
                        TypeSelector(
                          type: FileType.any,
                          selector: Row(
                            children: <Widget>[
                              Icon(Icons.add_circle),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text("Adicionar documentos"),
                              ),
                            ],
                          ),
                        ),
                      ],
                      onFileLoading: (val) {
                        print(val);
                      },
                    ),
                    SizedBox(
                      height: AppSize.s15,
                    ),
                    FormBuilderTextField(
                      name: 'description',
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Uma descrição',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: AppSize.s15,
                    ),
                    BlocBuilder<BloodCubit, BloodState>(
                      builder: (context, state) {
                        if (state is BloodLoading) {
                          return Text("Buscando os grupos sanguíneos");
                        } else if (state is BloodLoaded) {
                          final bloods = state.bloods;
                          return Container(
                            child: DropdownButtonFormField2<String>(
                              isExpanded: true,
                              value: blood.text,
                              decoration: InputDecoration(
                                hintText: 'Selecionar Grupo Snguíneo',
                                suffixIcon: bloodIcon,
                              ),
                              hint: const Text(
                                'Selecionar Grupo Snguíneo',
                                style: TextStyle(fontSize: 14),
                              ),
                              items: bloods
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item.type,
                                        child: Text(
                                          item.type,
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select gender.';
                                }
                                return null;
                              },
                              onChanged: (groupBlood) {
                                bloodSvg(groupBlood!);
                                blood.text = groupBlood;
                              },
                              buttonStyleData: const ButtonStyleData(
                                padding: EdgeInsets.only(right: 8),
                              ),
                              iconStyleData: const IconStyleData(
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black45,
                                ),
                                iconSize: 24,
                              ),
                              dropdownStyleData: DropdownStyleData(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                padding: EdgeInsets.symmetric(
                                    horizontal: AppSize.s10),
                              ),
                            ),
                          );
                        } else if (state is BloodFailure) {
                          return Text("Error");
                        }
                        return SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: Container(
            margin: EdgeInsets.all(AppMargin.m16),
            child: RoundedLoadingButton(
              color: AppColors.primaryColor,
              successColor: AppColors.green,
              child: Text(AppStrings.searchDonor,
                  style: TextStyle(color: Colors.white)),
              controller: _btnController,
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  Get.toNamed(Routes.searchResultRoute);
                  print("Hospital: ${locationHospital.text}");
                  print("Hospital: ${prediction!.latitude}");
                  print(
                      "FILE: ${_formKey.currentState!.fields['file']?.value}");
                  print(
                      "data: ${_formKey.currentState!.fields['date']?.value}");
                  print(
                      "HORA: ${_formKey.currentState!.fields['time']?.value}");
                  print(
                      "DESCRIPTION: ${_formKey.currentState!.fields['description']?.value}");
                  print("BLOOD: ${blood.text}");
                  _btnController.stop();
                } else {
                  _btnController.stop();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
