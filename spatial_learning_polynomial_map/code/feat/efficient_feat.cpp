#include<mex.h>
#include<cstdio>
#include<cstdlib>
#include "math.h"

void mexFunction(int nlhs,mxArray *plhs[],int nrhs, const mxArray *prhs[])
{
    double* u;
	double* u1;
	double* utem;
	double* utem1;
    
    double* diagMidx;
	double* diagSidx;
	double* maskidxM;
	double* maskidxS;
	double* label_index;
    
    double featdim;
	double featdimM;
	double featdimS;
    double Cs;
	int dimM;
	int dimS;
	int Num;
    double labeli;
    
    double Lam = sqrt(2.0);
    u  = mxGetPr(prhs[0]);
    u1 = mxGetPr(prhs[1]);
    utem  = mxGetPr(prhs[2]);
    utem1 = mxGetPr(prhs[3]);
    label_index = mxGetPr(prhs[5]);
    
    //-----------------------//
   diagMidx = mxGetPr(mxGetField(prhs[4],0,"diagMidx"));
   diagSidx = mxGetPr(mxGetField(prhs[4],0,"diagSidx"));
   maskidxM = mxGetPr(mxGetField(prhs[4],0,"maskidxM"));
   maskidxS = mxGetPr(mxGetField(prhs[4],0,"maskidxS"));
   featdim  = mxGetScalar(mxGetField(prhs[4],0,"dimension")); 
   featdimM = mxGetScalar(mxGetField(prhs[4],0,"featdimM"));
   featdimS = mxGetScalar(mxGetField(prhs[4],0,"featdimS"));
   const mwSize* dim_u  = mxGetDimensions(prhs[2]);
   const mwSize* dim_u1 = mxGetDimensions(prhs[3]);
   Num = dim_u[1];
   int dim_u_tem = dim_u[0];
   int dim_u_tem1 = dim_u1[0];
   //---------------------------//
    
   double* Kuv = new double [dim_u_tem];
   double* u_temi;
   double* u_temi1;
   double* corrfeatM = new double [dim_u_tem*dim_u_tem];
   double* corrfeatS = new double [dim_u_tem1*dim_u_tem1];
   
   const mwSize dimoutput[2]={featdim,1};
   plhs[0] = mxCreateNumericArray(2, dimoutput,  mxDOUBLE_CLASS, mxREAL);
   double* output = static_cast<double*>(mxGetData(plhs[0]));
   
   // initialization
      for (int featMi = 0 ; featMi!=int(featdimM); featMi++)
      output[featMi]= 0;
      
      for (int featSi = 0 ; featSi!=int(featdimS); featSi++)
      output[int(featSi+featdimM)] = 0;
      //-------------------------------//
   

        for(int i=0;i!=Num;i++)
	{
          u_temi =  utem  + i*dim_u_tem;
         u_temi1 = utem1  + i*dim_u_tem1;
         
         for(int i_u = 0; i_u != dim_u_tem; i_u++){
              Kuv[i_u] = u[i_u]-u_temi[i_u]; }
      
         for (int i_u_i = 0; i_u_i != dim_u_tem; i_u_i ++)
	       for (int i_u_j = 0; i_u_j != dim_u_tem; i_u_j++){
             corrfeatM[i_u_i*dim_u_tem+i_u_j] = Kuv[i_u_i]*Kuv[i_u_j];}
          
          for (int d_u_i = 0; d_u_i != dim_u_tem; d_u_i ++) {   
		 corrfeatM[int(diagMidx[d_u_i])-1] = corrfeatM[int(diagMidx[d_u_i])-1]/Lam;}
        
         for (int i_u1_i = 0 ; i_u1_i != dim_u_tem1; i_u1_i ++)
             for (int i_u1_j = 0 ; i_u1_j != dim_u_tem1; i_u1_j ++){
				 corrfeatS[i_u1_i*dim_u_tem1+i_u1_j]= u1[i_u1_i]*u_temi1[i_u1_j]+u1[i_u1_j]*u_temi1[i_u1_i];}
         
          for (int d_u1_i = 0; d_u1_i != dim_u_tem1; d_u1_i ++){
              corrfeatS[int(diagSidx[d_u1_i])-1] = corrfeatS[int(diagSidx[d_u1_i])-1]/Lam;}
         
         //-----------------------------------//
         
         labeli = label_index[i];
         
         for (int featMi = 0 ; featMi!=int(featdimM); featMi++)
        output[featMi]= output[featMi]+labeli*corrfeatM[int(maskidxM[featMi])-1];

         for (int featSi = 0 ; featSi!=int(featdimS); featSi++)
        output[int(featSi+featdimM)] = output[int(featSi+featdimM)]+labeli*corrfeatS[int(maskidxS[featSi])-1];
     }
  
       delete [] Kuv;
	   delete [] corrfeatM;
	   delete [] corrfeatS;
 
}