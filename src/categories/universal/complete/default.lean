-- Copyright (c) 2017 Scott Morrison. All rights reserved.
-- Released under Apache 2.0 license as described in the file LICENSE.
-- Authors: Scott Morrison

import categories.universal.instances
import categories.discrete_category
import categories.opposites
import categories.universal.complete.lemmas.limit_functoriality

open category_theory
open category_theory.initial
open category_theory.types

namespace category_theory.universal

universes u₁ u₂ 

class Complete (C : Type (u₁+1)) [large_category C] := 
  (limitCone : Π {J : Type u₁} [small_category J] (F : J ↝ C), LimitCone F)

class Cocomplete (C : Type (u₁+1)) [large_category C] := 
  (colimitCocone : Π {J : Type u₁} [small_category J] (F : J ↝ C), ColimitCocone F)

variable {C : Type (u₁+1)}
variable [large_category C]
variable {J : Type u₁}
variables [small_category J]

definition limitCone [Complete C] (F : J ↝ C) := Complete.limitCone F
definition limit     [Complete C] (F : J ↝ C) := (Complete.limitCone F).terminal_object.cone_point

definition colimitCocone [Cocomplete C] (F : J ↝ C) := Cocomplete.colimitCocone F
definition colimit       [Cocomplete C] (F : J ↝ C) := (Cocomplete.colimitCocone F).initial_object.cocone_point

open category_theory.universal.lemmas.limit_functoriality

definition functorial_Limit [Complete C] : (J ↝ C) ↝ C := {
  onObjects     := λ F, (limitCone F).terminal_object.cone_point,
  onMorphisms   := λ F G τ, let lim_F := (limitCone F) in
                            let lim_G := (limitCone G) in
                              (lim_G.morphism_to_terminal_object_from {
                                cone_point    := _,
                                cone_maps     := (λ j, (lim_F.terminal_object.cone_maps j) ≫ (τ.components j))
                             }).cone_morphism
}

definition functorial_Colimit [Cocomplete C] : (J ↝ C) ↝ C := {
  onObjects     := λ F, (colimitCocone F).initial_object.cocone_point,
  onMorphisms   := λ F G τ, let colim_F := (colimitCocone F) in
                            let colim_G := (colimitCocone G) in
                              (colim_F.morphism_from_initial_object_to {
                                cocone_point    := _,
                                cocone_maps     := (λ j, (τ.components j) ≫ (colim_G.initial_object.cocone_maps j))
                             }).cocone_morphism
}

end category_theory.universal