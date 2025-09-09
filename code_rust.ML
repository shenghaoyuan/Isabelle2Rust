(*  Title:      Tools/Code/code_ml.ML
    Author:     Florian Haftmann, TU Muenchen

Serializer for SML and Caml.
*)

signature CODE_RUST =
sig
  val target: string
end;

structure Code_ML : CODE_RUST =
struct

open Basic_Code_Symbol;     
open Basic_Code_Thingol;
open Code_Printer;      

infixr 5 @@;         
infixr 5 @|;


(** generic **)

val target = "Rust";

(** print debug info **)

fun wrap_args sl = "(" ^ String.concatWith ", " sl ^ ")"
fun wrap_list sl = "[" ^ String.concatWith ", " sl ^ "]"
fun wrap_struct sl = "{" ^ String.concatWith ", " sl ^ "}"
fun print_debug_info_itype (ITyVar itypvn) = itypvn
  | print_debug_info_itype (vn `%% itypes) = 
    vn ^"`%%"^ wrap_list (map print_debug_info_itype itypes) 
fun print_debug_info_dict (Dict (classrels, plain_dict)) = 
  let 
    fun print_classrels classrels  = 
      wrap_list (map (fn (s1, s2) => wrap_args [s1, s2]) classrels) (*type class = string*)
  in
    wrap_args [print_classrels classrels , print_plain_dict plain_dict]
  end
and print_plain_dict (Dict_Const ((s, c), args)) = 
    wrap_args [(wrap_args [s, c]),
      wrap_list (map (fn (ityp, dicts) =>
        wrap_args [(print_debug_info_itype ityp), wrap_list (map print_debug_info_dict dicts)]) args)]  
  | print_plain_dict (Dict_Var {var, index, length, class, unique}) = 
    wrap_struct ["var: "^var, "index: "^Int.toString index, "length: "^Int.toString length, 
      "class: "^class, "unique: "^Bool.toString unique]
fun print_debug_info_sym sym = case sym of
    Constant a => "Constant="^a 
    | Type_Constructor b => "Type_Constructor="^b
    | Type_Class c =>"Type_Class="^ c 
    | Class_Relation (d1, d2) => "Class_Relation="^wrap_args [d1, d2]
    | Class_Instance (e1, e2) => "Class_Instance="^wrap_args [e1, e2]
    | Module f => "Module"^f 
fun print_debug_info_const {sym, typargs, dicts, dom, range, annotation} = 
  let 
    val sym_base = print_debug_info_sym sym
    val annot = case annotation of 
      NONE => "NONE"
      | SOME a => print_debug_info_itype a
  in
    wrap_struct ["sym :"^sym_base, "typargs: "^wrap_list (map print_debug_info_itype typargs),
      "dicts: "^wrap_list ((map (wrap_list o (map print_debug_info_dict)) dicts)),
      "dom: "^wrap_list (map print_debug_info_itype dom),
      "range: "^print_debug_info_itype range, "annotation: "^annot]
  end
fun dest_vname v = case v of
  NONE => "Anonymous"
  | SOME vname => vname
fun print_debug_info_iterm (IConst const) = 
    print_debug_info_const const
  | print_debug_info_iterm (IVar vname) = 
    dest_vname vname
  | print_debug_info_iterm (t1 `$ t2) =
    "(" ^ print_debug_info_iterm t1 ^ "`$" ^ print_debug_info_iterm t2 ^ ")"
  | print_debug_info_iterm ((v, ityp1) `|=> (t, ityp2)) =
    wrap_args [wrap_args [dest_vname v, print_debug_info_itype ityp1], 
      wrap_args [print_debug_info_iterm t, print_debug_info_itype ityp2]]
  | print_debug_info_iterm (ICase {term, typ, clauses, primitive}) =
    wrap_struct ["term: "^print_debug_info_iterm term, "typ: "^print_debug_info_itype typ,
    "clauses: "^wrap_list (map (fn (t1, t2) 
      => wrap_args [print_debug_info_iterm t1, print_debug_info_iterm t2]) clauses),
    "primitive: "^print_debug_info_iterm primitive]
fun dest_typscheme (s, t) = 
  wrap_args [wrap_list (map (fn (t1, t2) => wrap_args [t1, wrap_list t2]) s), print_debug_info_itype t]
fun print_debug_info_thingol_stmt Code_Thingol.NoStmt = 
    "NoStmt"
  | print_debug_info_thingol_stmt (Code_Thingol.Fun ((scheme, args), _)) = 
    "Fun="^wrap_args [dest_typscheme scheme, wrap_list (map (fn ((ts, t), _) =>
      wrap_args [wrap_list (map print_debug_info_iterm ts), print_debug_info_iterm t]) args)]
  | print_debug_info_thingol_stmt (Code_Thingol.Datatype (vns, cos)) = 
    "Datatype="^wrap_args [wrap_list vns, wrap_list (map (fn ((v, args), itypes) => 
      wrap_args [wrap_args [v, wrap_list args], wrap_list (map print_debug_info_itype itypes)]) cos)]
  | print_debug_info_thingol_stmt (Code_Thingol.Datatypecons v) = 
    "Datatypecons="^v   
  | print_debug_info_thingol_stmt (Code_Thingol.Class _) = 
    "Class"
  | print_debug_info_thingol_stmt (Code_Thingol.Classrel (c1, c2)) = 
    "Classrel="^wrap_args[c1, c2]
  | print_debug_info_thingol_stmt (Code_Thingol.Classparam p) = 
    "Classparam="^p         
  | print_debug_info_thingol_stmt (Code_Thingol.Classinst {class, tyco, vs, ...}) = 
    "Classinst="^wrap_struct ["class: "^class, "tyco: "^tyco, 
      "vs: "^wrap_list (map (fn (t1, t2) => wrap_args [t1, wrap_list t2]) vs), "..."]
fun print_debug_info_node ((sym, stmt), syms) =
  wrap_struct [ "key: "^print_debug_info_sym sym, "stmt: "^print_debug_info_thingol_stmt stmt,
   "children: "^wrap_list (map print_debug_info_sym syms)]


datatype ml_binding =
    ML_Function of string * (typscheme * ((iterm list * iterm) * (thm option * bool)) list)
  | ML_Instance of (string * class) * { class: class, tyco: string, vs: (vname * sort) list,
        superinsts: (class * (itype * dict list) list) list,
        inst_params: ((string * (const * int)) * (thm * bool)) list,
        superinst_params: ((string * (const * int)) * (thm * bool)) list };

datatype ml_stmt =
    ML_Exc of string * (typscheme * int)
  | ML_Val of ml_binding
  | ML_Funs of (Code_Namespace.export * ml_binding) list * Code_Symbol.T list
  | ML_Datas of (string * (vname list * ((string * vname list) * itype list) list)) list
  | ML_Class of string * (vname * ((class * class) list * (string * itype) list));

fun print_product _ [] = NONE
  | print_product print [x] = SOME (print x)
  | print_product print xs = (SOME o enum " *" "" "") (map print xs);

fun tuplify _ _ [] = NONE
  | tuplify print fxy [x] = SOME (print fxy x)
  | tuplify print _ xs = SOME (enum "," "(" ")" (map (print NOBR) xs));

(** Caml serializer **)

val print_rust_string =
  let
    (*fun unicode i = "\\u" ^ align_right "0" 4 (Int.fmt StringCvt.HEX i)*)
    fun unicode i = "\\u{" ^ Int.toString i ^ "}"
    fun char "\"" = "\\\""
      | char "\\" = "\\\\"
      | char c =
         let val i = ord c
         in if i < 32 orelse i > 126
          then unicode i
          else if i >= 128
          then error "non-ASCII byte in Rust string literal"
          else c
        end;
  in quote o translate_string char end;

fun print_ocaml_stmt tyco_syntax const_syntax reserved is_constr deresolve 
  is_inf_typeco is_invdependent_typecos =
  let
    val _ = tracing "print_ocmal_stmt IN"
    val deresolve_const = deresolve o Constant;
    val deresolve_classrel = deresolve o Class_Relation;
    val deresolve_inst = deresolve o Class_Instance;
    fun box s = "Box<"^s^">"
    fun deref s = "*"^s
    fun print_tyco_expr_gen is_head (sym, tys) = 
      let
        val isinf = is_inf_typeco (sym, tys)
        val tyconame = if (isinf andalso (not is_head)) then box (deresolve sym)
          else deresolve sym
      in
        case tys  
       of [] => str tyconame
        | [ty] =>
          concat [print_typ_gen is_head BR ty, str tyconame]
        | tys =>
          concat [enum "," "(" ")" (map (print_typ_gen is_head BR) tys), str tyconame]
      end
    and print_typ_gen is_head fxy (tyco `%% tys) = (case tyco_syntax tyco
         of NONE => print_tyco_expr_gen is_head (Type_Constructor tyco, tys)
          | SOME (_, print) => print (print_typ_gen is_head) fxy tys)
      | print_typ_gen is_head fxy (ITyVar v) = str ("'" ^ v);
    fun print_tyco_expr (sym, tys) = print_tyco_expr_gen true (sym, tys);
    fun print_typ fxy ty = print_typ_gen true fxy ty;
    fun print_dicttyp (class, ty) = print_tyco_expr (Type_Class class, [ty]);
    fun print_typscheme_prefix (vs, p) = enum " ->" "" ""
      (map_filter (fn (v, sort) =>
        (print_product (fn class => print_dicttyp (class, ITyVar v)) sort)) vs @| p);
    fun print_typscheme (vs, ty) = print_typscheme_prefix (vs, print_typ NOBR ty);
    fun print_dicttypscheme (vs, class_ty) = print_typscheme_prefix (vs, print_dicttyp class_ty);
    val print_classrels =
      fold_rev (fn classrel => fn p => Pretty.block [p, str ".", (str o deresolve_classrel) classrel])
    fun print_dict is_pseudo_fun fxy (Dict (classrels, x)) =
      print_plain_dict is_pseudo_fun fxy x
      |> print_classrels classrels
    and print_plain_dict is_pseudo_fun _ (Dict_Const (inst, dss)) =
          brackify BR ((str o deresolve_inst) inst ::
            (if is_pseudo_fun (Class_Instance inst) then [str "()"]
            else map_filter (print_dicts is_pseudo_fun BR o snd) dss))
      | print_plain_dict _ _ (Dict_Var { var, index, length, ... }) =
          str (if length = 1 then "_" ^ Name.enforce_case true var
            else "_" ^ Name.enforce_case true var ^ string_of_int (index + 1))
    and print_dicts is_pseudo_fun = tuplify (print_dict is_pseudo_fun);
    val print_dict_args = map_filter (fn (v, sort) => print_dicts (K false) BR
      (map_index (fn (i, _) => Dict ([],
         Dict_Var { var = v, index = i, length = length sort, class = nth sort i, unique = true })) sort));
    fun print_term is_pseudo_fun some_thm vars fxy (IConst const) =
          print_app is_pseudo_fun some_thm vars fxy (const, [])
      | print_term _ _ _ _ (IVar NONE) =
          str "_"
      | print_term _ _ vars _ (IVar (SOME v)) =
          str (lookup_var vars v)
      | print_term is_pseudo_fun some_thm vars fxy (t as t1 `$ t2) =
          (case Code_Thingol.unfold_const_app t
           of SOME app => print_app is_pseudo_fun some_thm vars fxy app
            | NONE => brackify fxy [print_term is_pseudo_fun some_thm vars NOBR t1,
                print_term is_pseudo_fun some_thm vars BR t2])
      | print_term is_pseudo_fun some_thm vars _ (t as _ `|=> _) =
          let
            val (binds, t') = Code_Thingol.unfold_pat_abs t;
            val (ps, vars') = fold_map (print_bind is_pseudo_fun some_thm BR o fst) binds vars;
          in brackets (str "fun" :: ps @ str "->" @@ print_term is_pseudo_fun some_thm vars' NOBR t') end
      | print_term is_pseudo_fun some_thm vars fxy (ICase case_expr) =
          (case Code_Thingol.unfold_const_app (#primitive case_expr)
           of SOME (app as ({ sym = Constant const, ... }, _)) =>
                if is_none (const_syntax const)
                then print_case is_pseudo_fun some_thm vars fxy case_expr
                else print_app is_pseudo_fun some_thm vars fxy app
            | NONE => print_case is_pseudo_fun some_thm vars fxy case_expr)
    and print_app_expr is_pseudo_fun some_thm vars (app as ({ sym, dicts, dom, ... }, ts)) =
      if is_constr sym then
        let val wanted = length dom in
          if length ts = wanted
          then (str o deresolve) sym
            :: the_list (tuplify (print_term is_pseudo_fun some_thm vars) BR ts)
          else [print_term is_pseudo_fun some_thm vars BR (Code_Thingol.saturated_application wanted app)]
        end
      else if is_pseudo_fun sym
        then (str o deresolve) sym @@ str "()"
      else (str o deresolve) sym :: map_filter (print_dicts is_pseudo_fun BR) dicts
        @ map (print_term is_pseudo_fun some_thm vars BR) ts
    and print_app is_pseudo_fun some_thm vars = gen_print_app (print_app_expr is_pseudo_fun)
      (print_term is_pseudo_fun) const_syntax some_thm vars
    and print_bind is_pseudo_fun = gen_print_bind (print_term is_pseudo_fun)
    and print_case _ _ _ _ { clauses = [], ... } =
          (concat o map str) ["panic!(\"empty case\")", "\"empty case\""]
      | print_case is_pseudo_fun some_thm vars _ (case_expr as { clauses = [_], ... }) =
          let
            val (binds, body) = Code_Thingol.unfold_let (ICase case_expr);
            fun print_let ((pat, _), t) vars =
              vars
              |> print_bind is_pseudo_fun some_thm NOBR pat
              |>> (fn p => concat
                  [str "let", p, str "=", print_term is_pseudo_fun some_thm vars NOBR t, str "in"])
            val (ps, vars') = fold_map print_let binds vars;
          in
            brackets [Pretty.chunks ps, print_term is_pseudo_fun some_thm vars' NOBR body]
          end
      | print_case is_pseudo_fun some_thm vars _ { term = t, typ = _, clauses = clause :: clauses, ... } =
          let
            fun print_select delim (pat, body) =
              let
                val (p, vars') = print_bind is_pseudo_fun some_thm NOBR pat vars;
              in concat [str delim, p, str "->", print_term is_pseudo_fun some_thm vars' NOBR body] end;
          in
            brackets (
              str "match"
              :: print_term is_pseudo_fun some_thm vars NOBR t
              :: print_select "with" clause
              :: map (print_select "|") clauses
            )
          end;
    fun print_val_decl print_typscheme (sym, typscheme) = concat
      [str "val", str (deresolve sym), str ":", print_typscheme typscheme];
    fun print_datatype_decl definer (tyco, (vs, cos)) =
      let
        fun print_debug_info_co ((co, vs), tys) = wrap_args[wrap_args [co, wrap_list(vs)], wrap_list (map print_debug_info_itype tys)]
        val _ = tracing ("print_datatype_decl TYCO=" ^ tyco ^ "\nVS=" ^ wrap_list vs ^ "\nCOS=" ^ wrap_list (map print_debug_info_co cos))
        fun print_co ((co, _), []) = str (deresolve_const co)
          | print_co ((co, _), tys) = concat [str (deresolve_const co), str "(",
              enum " *" "" "" (map (print_typ_gen false (INFX (2, X))) tys), str")"];
      in
        concat (flat [
          [str definer,
          print_tyco_expr (Type_Constructor tyco, map ITyVar vs),
          str "{\n"],
          separate (str ",\n") (map print_co cos),
          [str "}"]
        ])
      end;
    fun print_def is_pseudo_fun needs_typ definer
          (ML_Function (const, (vs_ty as (vs, ty), eqs))) =
          let
            val _ = tracing ("print_def FUN of " ^const^ " = "^
              print_debug_info_thingol_stmt (Code_Thingol.Fun ((vs_ty,eqs),NONE)))
            fun print_eqn ((ts, t), (some_thm, _)) =
              let
                val vars = reserved
                  |> intro_base_names_for (is_none o const_syntax)
                      deresolve (t :: ts)
                  |> intro_vars (build (fold Code_Thingol.add_varnames ts));
              in concat [
                (Pretty.block o commas)
                  (map (print_term is_pseudo_fun some_thm vars NOBR) ts),
                str "->",
                print_term is_pseudo_fun some_thm vars NOBR t
              ] end;
            fun print_eqns is_pseudo [((ts, t), (some_thm, _))] =
                  let
                    val vars = reserved
                      |> intro_base_names_for (is_none o const_syntax)
                          deresolve (t :: ts)
                      |> intro_vars (build (fold Code_Thingol.add_varnames ts));
                  in
                    concat (
                      (if is_pseudo then [str "()"]
                        else map (print_term is_pseudo_fun some_thm vars BR) ts)
                      @ str "="
                      @@ print_term is_pseudo_fun some_thm vars NOBR t
                    )
                  end
              | print_eqns _ ((eq as (([_], _), _)) :: eqs) =
                  Pretty.block (
                    str "="
                    :: Pretty.brk 1
                    :: str "function"
                    :: Pretty.brk 1
                    :: print_eqn eq
                    :: maps (append [Pretty.fbrk, str "|", Pretty.brk 1]
                          o single o print_eqn) eqs
                  )
              | print_eqns _ (eqs as eq :: eqs') =
                  let
                    val vars = reserved
                      |> intro_base_names_for (is_none o const_syntax)
                           deresolve (map (snd o fst) eqs)
                    val dummy_parms = (map str o aux_params vars o map (fst o fst)) eqs;
                  in
                    Pretty.block (
                      Pretty.breaks dummy_parms
                      @ Pretty.brk 1
                      :: str "="
                      :: Pretty.brk 1
                      :: str "match"
                      :: Pretty.brk 1
                      :: (Pretty.block o commas) dummy_parms
                      :: Pretty.brk 1
                      :: str "with"
                      :: Pretty.brk 1
                      :: print_eqn eq
                      :: maps (append [Pretty.fbrk, str "|", Pretty.brk 1]
                           o single o print_eqn) eqs'
                    )
                  end;
            val prolog = if needs_typ then
              concat [str definer, (str o deresolve_const) const, str ":", print_typ NOBR ty]
                else (concat o map str) [definer, deresolve_const const];
          in pair
            (print_val_decl print_typscheme (Constant const, vs_ty))
            (concat (
              prolog
              :: print_dict_args vs
              @| print_eqns (is_pseudo_fun (Constant const)) eqs
            ))
          end
      | print_def is_pseudo_fun _ definer
          (ML_Instance (inst as (tyco, class), { vs, superinsts, inst_params, ... })) =
          let
            fun print_super_instance (super_class, dss) =
              concat [
                (str o deresolve_classrel) (class, super_class),
                str "=",
                print_dict is_pseudo_fun NOBR (Dict ([], Dict_Const ((tyco, super_class), dss)))
              ];
            fun print_classparam_instance ((classparam, (const, _)), (thm, _)) =
              concat [
                (str o deresolve_const) classparam,
                str "=",
                print_app (K false) (SOME thm) reserved NOBR (const, [])
              ];
          in pair
            (print_val_decl print_dicttypscheme
              (Class_Instance inst, (vs, (class, tyco `%% map (ITyVar o fst) vs))))
            (concat (
              str definer
              :: (str o deresolve_inst) inst
              :: (if is_pseudo_fun (Class_Instance inst) then [str "()"]
                  else print_dict_args vs)
              @ str "="
              @@ brackets [
                enum_default "()" ";" "{" "}" (map print_super_instance superinsts
                  @ map print_classparam_instance inst_params),
                str ":",
                print_dicttyp (class, tyco `%% map (ITyVar o fst) vs)
              ]
            ))
          end;
    (*fun print_stmt: Code_Namespace.export -> ml_stmt -> Pretty.T list * Pretty.T*)
     fun print_stmt _ (ML_Exc (const, (vs_ty, n))) = pair
          [print_val_decl print_typscheme (Constant const, vs_ty)]
          (String.concat (
            "let"
            :: deresolve_const const
            :: replicate n "_"
            @ "="
            :: "failwith"
            @@ print_rust_string const
          ) 
          |> str)
      | print_stmt _ (ML_Val binding) =
          let
            val (sig_p, p) = print_def (K false) true "let" binding
          in pair
            [sig_p]
            (p)
          end
      | print_stmt _ (ML_Funs ((export, binding) :: exports_bindings, pseudo_funs)) =
          let
            val print_def' = print_def (member (op =) pseudo_funs) false;
            fun print_pseudo_fun sym = concat [
                str "let",
                (str o deresolve) sym,
                str "=",
                (str o deresolve) sym,
                str "();;"
              ];
            val (sig_ps, (ps, p)) = (apsnd split_last o split_list)
              (print_def' "let rec" binding :: map (print_def' "and" o snd) exports_bindings);
            val pseudo_ps = map print_pseudo_fun pseudo_funs;
          in pair
            (map_filter (fn (export, p) => if Code_Namespace.not_private export then SOME p else NONE)
              ((export :: map fst exports_bindings) ~~ sig_ps))
            (Pretty.chunks (ps @ p :: pseudo_ps))
          end
     | print_stmt _ (ML_Datas [(tyco, (vs, []))]) =
          let
            val ty_p = print_tyco_expr (Type_Constructor tyco, map ITyVar vs);
          in
            pair
            [concat [str "type", ty_p]]
            (concat [str "type", ty_p, str "=", str "EMPTY__"])
          end
     | print_stmt export (ML_Datas (datas)) = 
          let
            val decl_ps = map (print_datatype_decl "enum") datas;
            val (ps, p) = split_last decl_ps;
          in pair
            (if Code_Namespace.is_public export
              then decl_ps
              else map (fn (tyco, (vs, _)) =>
                concat [str "type", print_tyco_expr (Type_Constructor tyco, map ITyVar vs)])
                (datas))
            (Pretty.chunks (ps @| p))
          end
     | print_stmt export (ML_Class (class, (v, (classrels, classparams)))) =
          let
            fun print_field s p = concat [str s, str ":", p];
            fun print_super_class_field (classrel as (_, super_class)) =
              print_field (deresolve_classrel classrel) (print_dicttyp (super_class, ITyVar v));
            fun print_classparam_decl (classparam, ty) =
              print_val_decl print_typscheme
                (Constant classparam, ([(v, [class])], ty));
            fun print_classparam_field (classparam, ty) =
              print_field (deresolve_const classparam) (print_typ NOBR ty);
            val w = "_" ^ Name.enforce_case true v;
            fun print_classparam_proj (classparam, _) =
              (concat o map str) ["let", deresolve_const classparam, w, "=",
                w ^ "." ^ deresolve_const classparam ^ ";;"];
            val type_decl_p = concat [
                str "type",
                print_dicttyp (class, ITyVar v),
                str "=",
                enum_default "unit" ";" "{" "}" (
                  map print_super_class_field classrels
                  @ map print_classparam_field classparams
                )
              ];
          in pair
           (if Code_Namespace.is_public export
              then type_decl_p :: map print_classparam_decl classparams
              else if null classrels andalso null classparams
              then [type_decl_p] (*work around weakness in export calculation*)
              else [concat [str "type", print_dicttyp (class, ITyVar v)]])
            (Pretty.chunks (
              type_decl_p
              :: map print_classparam_proj classparams
            ))
          end;
  in print_stmt end;

fun print_ocaml_module name decls body =
  Pretty.chunks2 (
    Pretty.chunks [
      str ("module " ^ name ^ " : sig"),
      (indent 2 o Pretty.chunks) decls,
      str "end = struct"
    ]
    :: body
    @| str ("end;; (*struct " ^ name ^ "*)")
  );

val literals_ocaml = let
  fun numeral_ocaml k = if k < 0
    then "(Z.neg " ^ numeral_ocaml (~ k) ^ ")"
    else if k <= 1073741823
      then "(Z.of_int " ^ string_of_int k ^ ")"
      else "(Z.of_string " ^ quote (string_of_int k) ^ ")"
in Literals {
  literal_string = print_rust_string,
  literal_numeral = numeral_ocaml,
  literal_list = enum ";" "[" "]",
  infix_cons = (6, "::")
} end;

(** namify **)

fun variant_snake_case s ctxt =
  let
    val cs = String.explode s;
    fun to_snake_case cs =
      let
        fun is_upper c = Char.isUpper c;
        fun is_lower c = Char.isLower c;
        fun aux [] = []
          | aux [c] = [Char.toLower c]
          | aux (c1 :: c2 :: cs) =
              if is_upper c1 andalso is_lower c2 then
                #"_" :: Char.toLower c1 :: aux (c2 :: cs)
              else if is_upper c1 andalso is_upper c2 then
                Char.toLower c1 :: aux (c2 :: cs)
              else
                Char.toLower c1 :: aux (c2 :: cs)
        fun auxx [] = []
          | auxx [c] = [Char.toLower c]
          | auxx (c :: cs) = Char.toLower c :: aux cs
      in auxx cs end;
    val s_snake = to_snake_case cs
  in
    ctxt |> Name.variant (String.implode s_snake)
  end;

fun variant_upper_camel_case s ctxt =
  let
    val cs = String.explode s;
    fun to_upper_camel_case cs =
      let
        fun aux [] = []
          | aux [c] = [c]
          | aux (c1 :: c2 :: cs) =
            if (c1 = #"_") then Char.toUpper c2 :: aux cs
            else c1 :: aux (c2 :: cs)
        fun auxx [] = []
          | auxx [c] = [Char.toUpper c]
          | auxx (c :: cs) = Char.toUpper c :: aux cs
      in auxx cs end;
    val s_camel = to_upper_camel_case cs
  in
    ctxt |> Name.variant (String.implode s_camel)
  end;

(** SML/Caml generic part **)

fun ml_program_of_program ctxt module_name reserved identifiers =
  let
    fun namify_const variant base (nsp_const, nsp_type) =
      let
        val (base', nsp_const') = variant base nsp_const
      in (base', (nsp_const', nsp_type)) end;
    fun namify_type variant base (nsp_const, nsp_type) =
      let
        val (base', nsp_type') = variant base nsp_type
      in (base', (nsp_const, nsp_type')) end;
    fun namify_stmt (Code_Thingol.Fun _) = namify_const variant_snake_case
      | namify_stmt (Code_Thingol.Datatype _) = namify_type variant_upper_camel_case
      | namify_stmt (Code_Thingol.Datatypecons _) = namify_const variant_upper_camel_case
      | namify_stmt (Code_Thingol.Class _) = namify_type variant_upper_camel_case
      | namify_stmt (Code_Thingol.Classrel _) = namify_const variant_upper_camel_case
      | namify_stmt (Code_Thingol.Classparam _) = namify_const variant_upper_camel_case
      | namify_stmt (Code_Thingol.Classinst _) = namify_const variant_upper_camel_case;
    fun ml_binding_of_stmt (sym as Constant const, (export, Code_Thingol.Fun ((tysm as (vs, ty), raw_eqs), _))) =
          let
            val eqs = filter (snd o snd) raw_eqs;
            val (eqs', some_sym) = if null (filter_out (null o snd) vs) then case eqs
               of [(([], t), some_thm)] => if (not o null o fst o Code_Thingol.unfold_fun) ty
                  then ([(([IVar (SOME "x")], t `$ IVar (SOME "x")), some_thm)], NONE)
                  else (eqs, SOME (sym, member (op =) (Code_Thingol.add_constsyms t []) sym))
                | _ => (eqs, NONE)
              else (eqs, NONE)
          in ((export, ML_Function (const, (tysm, eqs'))), some_sym) end
      | ml_binding_of_stmt (sym as Class_Instance inst, (export, Code_Thingol.Classinst (stmt as { vs, ... }))) =
          ((export, ML_Instance (inst, stmt)),
            if forall (null o snd) vs then SOME (sym, false) else NONE)
      | ml_binding_of_stmt (sym, _) =
          error ("Binding block containing illegal statement: " ^ 
            Code_Symbol.quote ctxt sym)
    fun modify_fun (sym, (export, stmt)) =
      let
        val ((export', binding), some_value_sym) = ml_binding_of_stmt (sym, (export, stmt));
        val ml_stmt = case binding
         of ML_Function (const, ((vs, ty), [])) =>
              ML_Exc (const, ((vs, ty),
                (length o filter_out (null o snd)) vs + (length o fst o Code_Thingol.unfold_fun) ty))
          | _ => case some_value_sym
             of NONE => ML_Funs ([(export', binding)], [])
              | SOME (sym, true) => ML_Funs ([(export, binding)], [sym])
              | SOME (sym, false) => ML_Val binding
      in SOME (export, ml_stmt) end;
    fun modify_funs stmts = single (SOME
      (Code_Namespace.Opaque, ML_Funs (map_split ml_binding_of_stmt stmts |> (apsnd o map_filter o Option.map) fst)))
    fun modify_datatypes stmts =
      let
        val datas = map_filter
          (fn (Type_Constructor tyco, (export, Code_Thingol.Datatype stmt)) => SOME (export, (tyco, stmt)) | _ => NONE) stmts
      in
        if null datas then [] (*for abstract types wrt. code_reflect*)
        else datas
          |> split_list
          |> apfst Code_Namespace.join_exports
          |> apsnd ML_Datas
          |> SOME
          |> single
      end;
    fun modify_class stmts =
      the_single (map_filter
        (fn (Type_Class class, (export, Code_Thingol.Class stmt)) => SOME (export, (class, stmt)) | _ => NONE) stmts)
      |> apsnd ML_Class
      |> SOME
      |> single;
    fun modify_stmts ([stmt as (_, (_, stmt' as Code_Thingol.Fun _))]) =
          if Code_Thingol.is_case stmt' then [] else [modify_fun stmt]
      | modify_stmts ((stmts as (_, (_, Code_Thingol.Fun _)) :: _)) =
          modify_funs (filter_out (Code_Thingol.is_case o snd o snd) stmts)
      | modify_stmts ((stmts as (_, (_, Code_Thingol.Datatypecons _)) :: _)) =
          modify_datatypes stmts
      | modify_stmts ((stmts as (_, (_, Code_Thingol.Datatype _)) :: _)) =
          modify_datatypes stmts
      | modify_stmts ((stmts as (_, (_, Code_Thingol.Class _)) :: _)) =
          modify_class stmts
      | modify_stmts ((stmts as (_, (_, Code_Thingol.Classrel _)) :: _)) =
          modify_class stmts
      | modify_stmts ((stmts as (_, (_, Code_Thingol.Classparam _)) :: _)) =
          modify_class stmts
      | modify_stmts ([stmt as (_, (_, Code_Thingol.Classinst _))]) =
          [modify_fun stmt]
      | modify_stmts ((stmts as (_, (_, Code_Thingol.Classinst _)) :: _)) =
          modify_funs stmts
      | modify_stmts stmts = error ("Illegal mutual dependencies: " ^
          (Library.commas o map (Code_Symbol.quote ctxt o fst)) stmts);
  in
    Code_Namespace.hierarchical_program ctxt {
      module_name = module_name, reserved = reserved, identifiers = identifiers,
      empty_nsp = (reserved, reserved), namify_module = pair, namify_stmt = namify_stmt,
      cyclic_modules = false, class_transitive = true,
      class_relation_public = true, empty_data = (),
      memorize_data = K I, modify_stmts = modify_stmts }
  end;

fun serialize_ml print_ml_module print_ml_stmt ml_extension ctxt
    { module_name, reserved_syms, identifiers, includes,
      class_syntax, tyco_syntax, const_syntax } program exports =
  let
    val _ = tracing ("PROGRAM="^String.concatWith "\n" (map print_debug_info_node (Code_Symbol.Graph.dest program)))

    (* build program *)
    val { deresolver, hierarchical_program = ml_program } =
      ml_program_of_program ctxt module_name (Name.make_context reserved_syms)
        identifiers exports program;

    (* global info look-up functions*)
    (** look up stmt info through sym in 
      program: Code_Symbol.Graph of (key: Code_Symbol.T, ord: Code_Thingol.stmt) 
    **)
    fun lookup_dependent_types_h program sym dpdncs =
      let 
        fun merge leq (L1 : string list, L2 : string list) = case (L1, L2) of
            ([], L2) => L2
          | (L1, []) => L1
          | (x1::rest1, x2::rest2) =>
              if leq(x1, x2) then x1 :: merge leq (rest1, L2)
              else x2 :: merge leq (L1, rest2);
        fun mergesort leq (lst : string list) =
          if (length lst) <= 1 then
            lst
          else
            let 
              val m = (length lst) div 2
              val (L1, L2) = (List.take(lst, m), List.drop(lst, m))
            in
              merge leq (mergesort leq L1, mergesort leq L2)
            end;
        fun dedup_sorted eq (lst : string list) = case lst of
            [] => []
          | [x] => [x]
          | x1 :: x2 :: rest =>
              if eq(x1, x2) then dedup_sorted eq (x2 :: rest)
              else x1 :: dedup_sorted eq (x2 :: rest);
        fun dedup (lst : string list) : string list = dedup_sorted (op=) (mergesort (op<=) lst)
        fun dest_itype (ITyVar vn) = [vn]
          | dest_itype (v `%% vns) = v::(List.concat(map dest_itype vns))
        fun dest_types (Code_Thingol.Datatype (vns, cos)) = 
          cos  
          |> map (fn ((_, _), ityps) => ityps)
          |> List.concat
          |> map dest_itype
          |> List.concat
          |> dedup
        val drct_dpdncs = dest_types (Code_Symbol.Graph.get_node program sym)
        val snd_dpdncs = drct_dpdncs@dpdncs 
          |> map (fn t => (Type_Constructor t)) 
          |> map (Code_Symbol.Graph.get_node program)
          |> map dest_types
          |> List.concat
          |> (fn l => l@drct_dpdncs@dpdncs)
          |> dedup
      in
        if (List.length dpdncs) = (List.length (snd_dpdncs))
        then dpdncs
        else lookup_dependent_types_h program sym snd_dpdncs
      end;
    fun lookup_dependent_types program sym = lookup_dependent_types_h program sym [];
    fun is_inf_typeco (sym, tys) =
      let
        val dpdncs = lookup_dependent_types program sym
        val typename = (fn (Type_Constructor x) => x) sym
        fun dest_itype (ITyVar vn) = vn
          | dest_itype (v `%% vns) = v 
        val types = map dest_itype tys
        val res = List.exists (fn s => s = typename) dpdncs
        val _ = tracing ("is_inftype TYPECO="^(print_debug_info_sym sym)^" DEPENDCENIES="^ (wrap_list dpdncs)
        ^"\nTYPES="^ (wrap_list types)^" RES="^Bool.toString res)
      in
        List.exists (fn s => s = typename) dpdncs
      end;
    fun is_invdependent_typecos {sym as (Constant t), typargs, dicts, dom, range, annotation} =
      let 
        fun dest_itype (ITyVar vn) = vn
          | dest_itype (v `%% vns) = v   
        val dttypcon = (fn (Code_Thingol.Datatypecons x) => x) (Code_Symbol.Graph.get_node program sym)
        val dom_typs = dom
          |> map dest_itype
          |> map (fn x => Type_Constructor x)
        val dom_dpdncs = map (lookup_dependent_types program) dom_typs
        val _ = tracing ("is_invdependent_typecos TYPECO="^t^
          "\nDOM="^(wrap_list (map dest_itype dom))^" DEPENDCENIES="^(wrap_list (map wrap_list dom_dpdncs)))
      in
        map (List.exists (fn s => s = dttypcon)) dom_dpdncs
    end;     


    (* print statements *)
    fun print_stmt prefix_fragments (_, (export, stmt)) = (print_ml_stmt
      tyco_syntax const_syntax (make_vars reserved_syms)
      (Code_Thingol.is_constr program) (deresolver prefix_fragments)
      is_inf_typeco is_invdependent_typecos)
      export stmt
      |> apfst (fn decl => if Code_Namespace.not_private export then SOME decl else NONE);

    (* print modules *)
    fun print_module _ base _ xs =
      let
        val (raw_decls, body) = split_list xs;
        val decls = maps these raw_decls
      in (NONE, print_ml_module base decls body) end;

    (* serialization *)
    val p = Pretty.chunks2 (map snd includes
      @ map snd (Code_Namespace.print_hierarchical {
        print_module = print_module, print_stmt = print_stmt,
        lift_markup = apsnd } ml_program));
  in
    (Code_Target.Singleton (ml_extension, p), try (deresolver []))
  end;

val serializer_ocaml : Code_Target.serializer =
  Code_Target.parse_args (Scan.succeed ()) #> K (serialize_ml print_ocaml_module print_ocaml_stmt "rs");


(** Isar setup **)

fun fun_syntax print_typ fxy [ty1, ty2] =
  brackify_infix (1, R) fxy (
    print_typ (INFX (1, X)) ty1,
    str "->",
    print_typ (INFX (1, R)) ty2
  );

val _ = Theory.setup
  (Code_Target.add_language
    (target, {serializer = serializer_ocaml, literals = literals_ocaml,
      check = {env_var = "ISABELLE_OCAMLFIND",
        make_destination = fn p => p + Path.explode "ROOT.ml"
          (*extension demanded by Caml compiler*),
        make_command = fn _ =>
          "\"$ISABELLE_OCAMLFIND\" ocamlopt -w -p-u -package zarith -linkpkg ROOT.ml </dev/null"},
      evaluation_args = []})
  #> Code_Target.set_printings (Type_Constructor ("fun",
    [(target, SOME (2, fun_syntax))]))
  #> fold (Code_Target.add_reserved target) [
    "Self", "abstract", "alignof", "and", "any", "as", "assert", "become", 
    "begin", "box", "break","case", "chan", "class", "const", "constraint", 
    "continue", "crate", "default", "defer", "do", "done", "downto", 
    "else", "end", "enum", "exception", "extern", "extern crate", "external", 
    "fallthrough", "false", "final", "fn", "for", "fun", "func", "function", "functor", 
    "go", "goto", "if", "if let", "impl", "import", "in", "include", "inherit", 
    "initializer", "interface", "lazy", "let", "loop", "macro", "map", "match", "method", 
    "mod", "module", "move", "mut", "mutable", "new", "object", "of", "offsetof", "open", 
    "or", "override", "package", "priv", "private", "proc", "pub", "pure", "range", 
    "rec", "ref", "return", "select", "self", "sig", "sizeof", "static", "struct", 
    "super", "switch", "then", "to", "trait", "true", "try", "type", "typeof", "unsafe",
    "unsized", "use", "val", "var", "virtual", "when", "where", "while", "with", "yield"]
  #> fold (Code_Target.add_reserved target) ["failwith", (*"mod",*) "Z"]);

end; (*struct*)
