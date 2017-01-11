//Exemple de struct c -> Script : struct permet de décrire
//chaque élément du code
#define bool int
#define true 1
#define false 0

#include <stdlib.h>

//0 - types d'objets
typedef enum Type Type;
typedef union MethodReturn MethodReturn;
typedef struct Class Class;
typedef struct Method Method;
typedef struct Field Field;
typedef struct Param Param;
typedef struct ListMethod ListMethod;
typedef struct ListField ListField;
typedef struct ListParam ListParam;

enum Type {integer, string, object};

//Variables globales
char ** classNames;

//1 - classe
// class nom (param, ...) [extends nom (arg, ...)] [bloc] is { ... }
struct Param
{
	char* name;
	Type t;
};

Param paramConstruct(char* name, Type t);

struct ListParam
{
	unsigned int count;
	Param* paramArray;
};

ListParam listParamEmpty();
ListParam listParam(int count, Param* fields);
void addParam(ListField* lf, Param p);

struct Field
{
	char* name;
	Type t;
	bool isVisible;
};

Field fieldConstruct(char* name, Type t);

struct ListField
{
	unsigned int count;
	Field* champA;
};

ListField listFieldEmpty();
ListField listMethod(int count, Field* fields);
void addField(ListField* lf, Field);

/*
//
// typedef union Value Value;
// union Value
// {
// 	char* strVal;
// 	int intVal;
// 	int ptr;
// }
*/
union MethodReturn
{
	Class* c;
	int i;
	char* s;
};

struct Method
{
	bool overrides;
	char* name;
	ListParam lParams;
	ListField classFields;
	Type* returnType;
	MethodReturn returned;
};

Method methodConstruct(char* name, ListParam lParam, ListField classFields, Type* returnType);

struct ListMethod
{
	unsigned int count;
	Method* methodArray;
};

ListMethod listEmpty();
ListMethod list(int count, Method* methods);
void addMethod(ListMethod * listMethod, Method m);

struct Class
{
	char* name;
	Method constructor;
	ListParam lParam;		//Si aucun, pas de param
	ListField lField;		//Si aucun, pas de champs
	ListMethod lMethod;		//Si aucun, pas de methodes
	Class* extendedC;	 	//Si NULL, n'herite de rien
};

Class classConstruct(char* name, Method constructor, ListParam lParam, ListField lField, ListMethod lMethod, Class* extendedC);
