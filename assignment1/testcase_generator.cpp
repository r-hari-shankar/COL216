#include <bits/stdc++.h>
using namespace std;

typedef long long ll;
typedef vector<int> vi;
typedef pair<int,int> pi;

int main() {
	// your code goes here
	int t;
	cin>>t;
	double area=0;
	for(int l=1;l<=t;l++)
	{
	    int x0,y0,x1,y1;
	    if(l==1){
	        cin>>x0>>y0>>x1>>y1;
	        l++;
	    }
	    else{
	        x0=x1;
	        y0=y1;
	        cin>>x1>>y1;
	    }
	    if(y1>=0 && y0>=0){
	        area+=(0.5)*(x1-x0)*(y1+y0);
	    }
	    else if(y1<0 && y0<0){
	        area+=(0.5)*(x0-x1)*(y1+y0);
	    }
	    else if(y1>=0 && y0<0){
	        double m=(y1-y0)/(x1-x0);
	        double c=y1-m*x1;
	        double xt=-c/m;
	        area+=(0.5)*(x0-xt)*(y0)+(0.5)*(x1-xt)*(y1);
	    }
	    else if(y1<0 && y0>=0){
	        double m=(y1-y0)/(x1-x0);
	        double c=y1-m*x1;
	        double xt=-c/m;
	        area+=(0.5)*(xt-x0)*(y0) + (0.5)*(xt-x1)*(y1);
	    }
	}
	cout<<area<<endl;
	
}
