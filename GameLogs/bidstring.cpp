// This program reads in a bid information string and converts in to a standard format
// The output  is a string of the form bidcount+double/redouble info +Win/Lose where bid is a number between 28 and 56 (both inclusive)
//  ,N indictating no double, D indicating Double and R indicating Redouble


#include <bits/stdc++.h> 
using namespace std; 


bool isbidnumber(string str){
  if((str=="28")||(str=="29")||(str=="30")||(str=="31")||(str=="32")||(str=="33")||(str=="34")||
     (str=="35")||(str=="36")||(str=="37")||(str=="38")||(str=="39")||(str=="40")||(str=="41")||
     (str=="42")||(str=="43")||(str=="44")||(str=="45")||(str=="46")||(str=="47")||(str=="48")||
     (str=="49")||(str=="40")||(str=="51")||(str=="52")||(str=="53")||(str=="54")||(str=="55")||(str=="56"))
    return 1;
  return 0;
}
  
// Driver function 
int main() 
{ 
  string str;
  getline(cin,str);

  string bidder="";
  string bidcount;
  char doublinginfo='N';
  char winlose;

  bool biddernotset=1;
  bool bidcountnotset=1;
  bool doublinginfonotset=1;

  const string doubled="X";
  const string redoubed="XX";
  const string win="Win" ;
  const string lost="Lost";
  // Used to split string around spaces. 
  istringstream ss(str); 
  
  // Traverse through all words 
  do { 
    // Read a word 
    string word; 
    ss >> word;
    if(biddernotset){
      bidder=bidder+word;
      if(bidder.length()>3){
	bidder=bidder.substr(0,4);
	biddernotset=0;
      }
    }
    if(!biddernotset && bidcountnotset){
      if(isbidnumber(word)){
	bidcount=word;
	bidcountnotset=0;
      }
    }
    if(doublinginfonotset&&!bidcountnotset){
      if(word==doubled){
	doublinginfo='D';
      }
      if(word==redoubed){
	doublinginfo='R';
      }
      if(word==win){
	winlose='W';
      }
      if(word==lost){
	winlose='L';
      }
    }
  } while (ss); 
  cout<<bidder<<"#"<<bidcount<<"#"<<doublinginfo<<"#"<<winlose<<endl;
  return 0; 
} 

