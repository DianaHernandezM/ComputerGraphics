#version 300 es        // NEWER VERSION OF GLSL
precision highp float; // HIGH PRECISION FLOATS

uniform float uTime;   // TIME, IN SECONDS
in vec3 vPos;          // POSITION IN IMAGE
out vec4 fragColor;    // RESULT WILL GO HERE

const int NS = 2; // Number of spheres in the scene
const int NL = 2; // Number of light sources in the scene

// Declarations of arrays for spheres, lights and phong shading:

vec3 Ldir[NL], Lcol[NL], Ambient[NS], Diffuse[NS];
vec4 Sphere[NS], Specular[NS],Specc;
vec3 N, P,c,Ambb,Dff;
float fl = 70.;
vec3 V,Vp,W,R,E,PhSpec, PhongR, getPhong;
float tMin = 1000.;
vec2 disCom;
float closeT;

float raySphere(vec3 V, vec3 W, vec4 S) {
Vp = V;
Vp -= S.xyz;
   float wvdot = dot(Vp,W);
   float sqwvd = wvdot*wvdot;
   float sqrad = S.w * S.w;
   float minimum;
   float discrim = sqwvd - dot (Vp, Vp) + sqrad;

    if(discrim>0.){
         disCom = vec2(-wvdot - discrim, -wvdot + discrim);
         minimum = min(disCom.x,disCom.y);
       //return the smaller value
   }
    if(minimum>0.){
        return minimum;
        }
   else
       return -1.;
}


vec3 phongSh(vec3 W, vec3 E, vec4 Spec, vec3 Diff, vec3 Amb, vec3 N) {

    vec3 PhongR = Amb;
    bool shadow = false;

    for(int i = 0; i < NL; i++){    
    vec3 L= Ldir[i];

                for(int a=0; a < NS; a++){
            float col = raySphere(P, L, Sphere[a]);
            if (col > 0.001){
                shadow = true;
            } else 
            shadow = false;
            }

    if(shadow == false){
        float d = max(0., dot(N,L));
        R = 2. * dot(N,L) * N - L;
        float spPow = pow(max(0.,dot(E,R)),Spec.w);
        PhSpec = Spec.xyz * spPow;
        PhongR += Lcol[i] * (Diff * d + PhSpec);
        }
    }
    return PhongR;
}

    //   if (!is_shadowed) {
    //       float d = max(0., dot(N, LDir));           // Diffuse value
    //       vec3  R = reflection(LDir, N);
    //       float s = pow(max(0., dot(E, R)), S.a);    // Specular value
    //       c += uLColors[i] * (d * D + s * S.rgb * .1*S.a);
    //   }



bool traceSphere(){
    tMin = 1000.;
        for(int i=0; i<NS; i++){
        float MyT = raySphere(V, W, Sphere[i]);
        float t = - dot(W,Vp) - sqrt(MyT);
        if (MyT > 0. && MyT < tMin) {
                P = V + MyT * W;
                N = normalize(P - Sphere[i].xyz);
                Ambb = Ambient[i];
                Dff = Diffuse[i];
                Specc = Specular[i];
                tMin = MyT;      
        }
        }return tMin < 1000.;
    
    }

void main() {

    Ldir[0] = normalize(vec3(70.,35.3,70.0)); //luz derecha
    Lcol[0] = vec3(1.,1.,1.);

    Ldir[1] = normalize(vec3(-3.,-0.5,-8.));
    Lcol[1] = vec3(.1,.07,.05);

    Sphere[0]   = vec4(-0.5,0.1,-2.5,.25); //esfera azul
    Ambient[0]  = vec3(0.,.1,.1);
    Diffuse[0]  = vec3(0.,.5,.5);
    Specular[0] = vec4(0.,1.,1.,10.); // 4th value is specular power

    Sphere[1]   = vec4(0.01,-.1,-2.1,0.4);
    Ambient[1]  = vec3(.1,.1,0.);
    Diffuse[1]  = vec3(.5,.5,0.);
    Specular[1] = vec4(1.,1.,1.,20.); // 4th value is specular power

    W = normalize(vec3(vPos.x, vPos.y, -fl));
    V = vec3(0.,0.,fl);
    E = -1. * W;

    if(!traceSphere()){
        c = vec3 (0.156,0.1,0.15); //background
    }
    else{  //si es verdadero
        c += phongSh(W,E,Specc,Dff,Ambb,N); 
    }
fragColor = vec4(c,1.);
 }




