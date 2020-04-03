#include<iostream>
#include<vector>
#include<string>
#include<iostream>
#include<fstream>
#include<stdio.h>
#include<stdlib.h>
using namespace std;


//This program reads in a file and a list of names.
// Every occurence of every id in list in the file is replaced with the first 4 characters in the name.
// For example if Mathew is a id in the list, every occurence of Mathew is replace by Mathe
int main(){
  
  ifstream input_htmlfile;
  string input_htmlfilename;
  //cout<<"Please type the name of the HTML file \n";
  cin>>input_htmlfilename;
  input_htmlfile.open(input_htmlfilename);

  ifstream full_id_file;
  string  full_id_filename;
  //cout<<"Please type the name of the id file \n";
  cin>>full_id_filename;
  full_id_file.open(full_id_filename);
  
  string full_id;
  string short_id;
  string command="cat "+input_htmlfilename+" >output.html";
  //cout<<command<<endl;
  system(command.c_str());
  //  while(full_id_file >> full_id){
  while(getline(full_id_file, full_id)){
    int a=full_id.length();
    a= min(4,a);
    short_id=full_id.substr(0,a);
    // Replace every occurence of full_id in file by short_id in input_htmlfile

    // Need to run the following command cat input_htmlfile_name|perl -pe 's/full_id/short_id/g'
    command = "cat output.html|perl -pe 's/"+full_id+"/"+short_id+"/g' >temp.html";
    //cout<<command<<endl;
    system(command.c_str());
    command = "mv temp.html output.html";
    system(command.c_str());
  }

}
