#include <bits/stdc++.h>
#include <vector>
#include<fstream>
using namespace std;

typedef long long ll;
typedef vector<int> vi;

int registers[32] = {0};  // initializing empty array of 32 size

string getR(int i) {
    if(i == 0) {return "$zero";}
    else if(i == 1) {return "$at";}
    else if(i == 2) {return "$v0";}
    else if(i == 3) {return "$v1";}
    else if(i == 4) {return "$a0";}
    else if(i == 5) {return "$a1";}
    else if(i == 6) {return "$a2";}
    else if(i == 7) {return "$a3";}
    else if(i == 8) {return "$t0";}
    else if(i == 9) {return "$t1";}
    else if(i == 10) {return "$t2";}
    else if(i == 11) {return "$t3";}
    else if(i == 12) {return "$t4";}
    else if(i == 13) {return "$t5";}
    else if(i == 14) {return "$t6";}
    else if(i == 15) {return "$t7";}
    else if(i == 16) {return "$s0";}
    else if(i == 17) {return "$s1";}
    else if(i == 18) {return "$s2";}
    else if(i == 19) {return "$s3";}
    else if(i == 20) {return "$s4";}
    else if(i == 21) {return "$s5";}
    else if(i == 22) {return "$s6";}
    else if(i == 23) {return "$s7";}
    else if(i == 24) {return "$t8";}
    else if(i == 25) {return "$t9";}
    else if(i == 26) {return "$k0";}
    else if(i == 27) {return "$k1";}
    else if(i == 28) {return "$gp";}
    else if(i == 29) {return "$sp";}
    else if(i == 30) {return "$fp";}
    else if(i == 31) {return "$ra";}
    else {return "";}
}

int getRegister(string s)
{
if (s.compare("$zero")==0 || s.compare("$0")==0) {return 0;}
else if(s.compare("$at")==0 || s.compare("$1")==0) {return 1;}
else if(s.compare("$v0")==0 || s.compare("$2")==0) {return 2;}
else if(s.compare("$v1")==0 || s.compare("$3")==0) {return 3;}
else if(s.compare("$a0")==0 || s.compare("$4")==0) {return 4;}
else if(s.compare("$a1")==0 || s.compare("$5")==0) {return 5;}
else if(s.compare("$a2")==0 || s.compare("$6")==0) {return 6;}
else if(s.compare("$a3")==0 || s.compare("$7")==0) {return 7;}
else if(s.compare("$t0")==0 || s.compare("$8")==0) {return 8;}
else if(s.compare("$t1")==0 || s.compare("$9")==0) {return 9;}
else if(s.compare("$t2")==0 || s.compare("$10")==0) {return 10;}
else if(s.compare("$t3")==0 || s.compare("$11")==0) {return 11;}
else if(s.compare("$t4")==0 || s.compare("$12")==0) {return 12;}
else if(s.compare("$t5")==0 || s.compare("$13")==0) {return 13;}
else if(s.compare("$t6")==0 || s.compare("$14")==0) {return 14;}
else if(s.compare("$t7")==0 || s.compare("$15")==0) {return 15;}
else if(s.compare("$s0")==0 || s.compare("$16")==0) {return 16;}
else if(s.compare("$s1")==0 || s.compare("$17")==0) {return 17;}
else if(s.compare("$s2")==0 || s.compare("$18")==0) {return 18;}
else if(s.compare("$s3")==0 || s.compare("$19")==0) {return 19;}
else if(s.compare("$s4")==0 || s.compare("$20")==0) {return 20;}
else if(s.compare("$s5")==0 || s.compare("$21")==0) {return 21;}
else if(s.compare("$s6")==0 || s.compare("$22")==0) {return 22;}
else if(s.compare("$s7")==0 || s.compare("$23")==0) {return 23;}
else if(s.compare("$t8")==0 || s.compare("$24")==0) {return 24;}
else if(s.compare("$t9")==0 || s.compare("$25")==0) {return 25;}
else if(s.compare("$k0")==0 || s.compare("$26")==0) {return 26;}
else if(s.compare("$k1")==0 || s.compare("$27")==0) {return 27;}
else if(s.compare("$gp")==0 || s.compare("$28")==0) {return 28;}
else if(s.compare("$sp")==0 || s.compare("$29")==0) {return 29;}
else if(s.compare("$fp")==0 || s.compare("$30")==0) {return 30;}
else if(s.compare("$ra")==0 || s.compare("$31")==0) {return 31;}
else {return -1;}
}

void printRegister() {
    for(int i = 0 ; i < 32; i++) {
        cout << getR(i) << " :: " << std::hex << "0x"  << registers[i] << endl;
    }
    cout << "---------------------------------------------------------------------------------" << endl << endl;
    cout << "---------------------------------------------------------------------------------" << endl; 
}

int main(int argc, char** argv) {
    if (argv[1] == NULL) {
        cout << "No file input received" << endl;
    }
    ifstream file_reader(argv[1]);

      
    map<string,int> labels;   // storing address of next lines corresponding to the given labels
    map<int, string> inst;  // instruction corresponding to a given address
    map<string, int> countOfInstructions;
    int memory[1048576];
    int PC = 0;
    int clockCycles = 0;

    countOfInstructions["add"] = 0;
    countOfInstructions["sub"] = 0;
    countOfInstructions["mul"] = 0;
    countOfInstructions["addi"] = 0;
    countOfInstructions["j"] = 0;
    countOfInstructions["beq"] = 0;
    countOfInstructions["bne"] = 0;
    countOfInstructions["slt"] = 0;
    countOfInstructions["lw"] = 0;
    countOfInstructions["sw"] = 0;

    //ifstream file_reader("input.txt");
    string line;
    long lambda = 0;
    while(getline(file_reader,line)){
        int i = 0;
        while(i < line.size() && line[i] == ' ') {
            i++;
        }
        if (line[i] == '#') {
            continue;
        } else if (line[line.size() - 1] == ':'){
            labels[line.substr(0, line.size()-1)]= lambda;
        } 
        // Add conditions for .text, .data .globl main etc. later
        else if (line.size() != 0 && i != line.size()) {
            memory[lambda] = lambda;
            for( char& c : line ) // for each char in the line,
            if( c == ',' ) c = ' ' ; // if it is a comma, replace it with a space
            inst[lambda] = line;      // the instruction line is corresponding to the address lambda
            lambda = lambda + 4;      // we increment the lambda by 4 for the next instuction
        }
        
    }
    registers[29] = 1048575-lambda;
    file_reader.close();
    
    while (inst.find(PC) != inst.end()) {
        string s = inst.find(PC)->second;
        istringstream sep(s);
        string one;
        sep >> one;

        if (registers[29] == 0) {
            cout << "Stack Overflow" << endl;
            return 0;
        }

        if (one == "add") {
            string reg1, reg2, reg3;
            sep >> reg1;
            sep >> reg2;
            sep >> reg3;

            int a = getRegister(reg1);
            int b = registers[getRegister(reg2)];
            int c;
            if (reg3[0] == '$') {
                c = registers[getRegister(reg3)];
            } else {
                c = stoi(reg3);
            }
            clockCycles++;
            countOfInstructions["add"]++;
            registers[a] = b + c;
            PC = PC + 4;
            printRegister();
        } else if (one == "sub") {
            string reg1, reg2, reg3;
            sep >> reg1;
            sep >> reg2;
            sep >> reg3;

            int a = getRegister(reg1);
            int b = registers[getRegister(reg2)];
            int c;
            if (reg3[0] == '$') {
                c = registers[getRegister(reg3)];
            } else {
                c = stoi(reg3);
            }

            registers[a] = b - c;
            clockCycles++;
            countOfInstructions["sub"]++;
            PC = PC + 4;
            printRegister();
        } else if (one == "mul") {
            string reg1, reg2, reg3;
            sep >> reg1;
            sep >> reg2;
            sep >> reg3;

            int a = getRegister(reg1);
            int b = registers[getRegister(reg2)];
            int c;
            if (reg3[0] == '$') {
                c = registers[getRegister(reg3)];
            } else {
                c = stoi(reg3);
            }

            registers[a] = b * c;
            clockCycles++;
            countOfInstructions["mul"]++;
            PC = PC + 4;
            printRegister();
        } else if (one == "addi") {
            string reg1, reg2, reg3;
            sep >> reg1;
            sep >> reg2;
            sep >> reg3;

            int a = getRegister(reg1);
            int b = registers[getRegister(reg2)];
            // Check c is hexadecimal or not....
            //
            //
            //
            //
            //
            //
            int c = stoi(reg3);

            registers[a] = b + c;
            clockCycles++;
            countOfInstructions["addi"]++;
            PC = PC + 4;
            printRegister();
        } else if (one == "slt") {
            string reg1, reg2, reg3;
            sep >> reg1;
            sep >> reg2;
            sep >> reg3;

            int a = getRegister(reg1);
            int b = registers[getRegister(reg2)];
            int c;
            if (reg3[0] == '$') {
                c = registers[getRegister(reg3)];
            } else {
                // Check c is hexadecimal or not....
                //
                //
                //
                //
                //
                //  
                c = stoi(reg3);
            }
            if (b < c) {
                registers[a] = 1;
            } else {
                registers[a] = 0;
            }

            PC = PC + 4;
            clockCycles++;
            countOfInstructions["slt"]++;
            printRegister();
        } else if (one == "j") {
            // label is an integer
            string reg;
            sep >> reg;
            if(labels.find(reg) != labels.end()) {
                PC = labels.find(reg)->second;
            } else {
                // convert reg from hexadecimal to decimal if..
                //
                //
                //
                //
                //
                //
                //
                //
                //
                //
                PC += (4 * stoi(reg));
            }
            clockCycles++;
            countOfInstructions["j"]++;
            printRegister();
        } else if (one == "beq"){
            string reg1,reg2,reg3;
            sep>> reg1;
            sep>> reg2;
            sep>> reg3;
            int a = registers[getRegister(reg1)];
            int b ;
            if (reg2[0] == '$') {
                b = registers[getRegister(reg2)];
            } else {
                // Check c is hexadecimal or not....
                //
                //
                //
                //
                //
                //
                b = stoi(reg2);
            }
            
            clockCycles++;
            countOfInstructions["beq"]++;
            printRegister();
            if(a==b){
                PC = labels.find(reg3)->second;
            } 
            else {
                PC = PC+4;
            }
        } else if( one == "bne"){
            string reg1,reg2,reg3;
            sep>> reg1;
            sep>> reg2;
            sep>> reg3;
            int a = registers[getRegister(reg1)];
            int b ;
            clockCycles++;
            countOfInstructions["bne"]++;
            if (reg2[0] == '$') {
                b = registers[getRegister(reg2)];
            } else {
                // Check c is hexadecimal or not....
                //
                //
                //
                //
                //
                //
                b = stoi(reg2);
            }
            
            if(a!=b){
                PC = labels.find(reg3)->second;
            } 
            else {
                PC = PC+4;
            }
            printRegister();
        } else if (one == "lw") {
            string reg1, s, offset, reg2;
            sep >> reg1;
            sep >> s;
            int a = getRegister(reg1);
            int h = 0;
            while(s[h] != '(') {
                h++;
            }
            if(h == 0) {
                offset = "0";
            } else if (h == s.size()) {
                h = -1;
                offset = "0";
            } else {
                for(int i = 0; i < h; i++) {
                    offset += s[i];
                }
            }
            //hexadecimal offset

            for(int i = h+1; i < s.size()-1; i++) {
                reg2 += s[i];
            }
            if(h == -1) {
                reg2 += s[s.size()-1];
            }
            //convert hexadecimal to integer string
            //
            //
            //
            //
            //
            //

            int b = getRegister(reg2);
            registers[a] = memory[b + stoi(offset)];
            clockCycles++;
            countOfInstructions["lw"]++;
            PC += 4;
            printRegister();
        } else if (one == "sw") {
            string reg1, s, offset, reg2;
            sep >> reg1;
            sep >> s;
            int a = getRegister(reg1);
            int h = 0;
            while(s[h] != '(') {
                h++;
            }
            if(h == 0) {
                offset = "0";
            } else if (h == s.size()) {
                h = -1;
                offset = "0";
            } else {
                for(int i = 0; i < h; i++) {
                    offset += s[i];
                }
            }
            //hexadecimal offset
            for(int i = h+1; i < s.size()-1; i++) {
                reg2 += s[i];
            }
            if(h == -1) {
                reg2 += s[s.size()-1];
            }
            //convert hexadecimal to integer string
            //
            //
            //
            //
            //
            int b = getRegister(reg2);
            memory[b + stoi(offset)] = registers[a];
            clockCycles++;
            countOfInstructions["sw"]++;
            PC += 4;
            printRegister();
        } else {
            cout << "Unidentifiable Command" << endl;
            return 0;
        }
    }

    cout << std::dec << "Total count of instructions: " << clockCycles << endl;

    map<string, int>::iterator itr; 
    for (itr = countOfInstructions.begin(); itr != countOfInstructions.end(); ++itr) { 
        cout << '\t' << itr->first 
             << '\t' << itr->second << '\n'; 
    } 
    cout << endl; 

     
    return 0;
}