import 'package:flutter/material.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';

class CountryPickerWidget extends StatefulWidget {
  final void Function(Country)? onCountrySelected;

  CountryPickerWidget({this.onCountrySelected});

  @override
  _CountryPickerWidgetState createState() => _CountryPickerWidgetState();
}

class _CountryPickerWidgetState extends State<CountryPickerWidget> {
  late Country _selectedCountry;

  @override
  void initState() {
    super.initState();
    // Initialize the selected country to the user's current country or a default country
    _selectedCountry = CountryPickerUtils.getCountryByIsoCode('AR');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showCountryPickerDialog,
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: <Widget>[
            CountryPickerUtils.getDefaultFlagImage(_selectedCountry),
            SizedBox(width: 1.0),
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  void _showCountryPickerDialog() {
    showDialog(
      context: context,
      builder: (context) => CountryPickerDialog(
        titlePadding: EdgeInsets.all(8.0),
        searchCursorColor: Colors.blueAccent,
        searchInputDecoration: InputDecoration(hintText: 'Buscar...'),
        isSearchable: true,
        title: Text('Seleccione su pais'),
        onValuePicked: (Country country) {
          setState(() {
            _selectedCountry = country;
          });
          if (widget.onCountrySelected != null) {
            widget.onCountrySelected!(country);
          }
        },
        itemBuilder: (Country country) => Container(
          child: Row(
            children: <Widget>[
              CountryPickerUtils.getDefaultFlagImage(country),
              SizedBox(width: 8.0),
              Text("${country.name} (${country.isoCode})"),
            ],
          ),
        ),
      ),
    );
  }
}
