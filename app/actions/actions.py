from typing import Any, Text, Dict, List

from rasa_sdk import Action, Tracker, FormValidationAction
from rasa_sdk.events import SlotSet, UserUtteranceReverted
from rasa_sdk.executor import CollectingDispatcher
from rasa_sdk.types import DomainDict


def repeat(tracker: Tracker, dispatcher: CollectingDispatcher):
    user_ignore_count = 2
    count = 0
    tracker_list = []

    while user_ignore_count > 0:
        event = tracker.events[count].get("event")
        if event == "user":
            user_ignore_count = user_ignore_count - 1
        if event == "bot":
            tracker_list.append(tracker.events[count])
        count = count - 1

    tracker_list.reverse()
    i = len(tracker_list) - 1

    while i >= 0:
        data = tracker_list[i].get("data")
        if data:
            if "buttons" in data:
                dispatcher.utter_message(
                    text=tracker_list[i].get("text"), buttons=data["buttons"])
            else:
                dispatcher.utter_message(text=tracker_list[i].get("text"))
            break
        i -= 1


class ValidateBookRoomInfo(FormValidationAction):
    def name(self) -> Text:
        return "validate_form_book_room"

    async def required_slots(
        self,
        domain_slots: List[Text],
        dispatcher: CollectingDispatcher,
        tracker: Tracker,
        domain: DomainDict,
    ) -> List[Text]:
        return ["number", "room_type"]

    async def extract_number(
        self,
        dispatcher: CollectingDispatcher,
        tracker: Tracker,
        domain: DomainDict,
    ) -> Dict[Text, Any]:
        return {"number": tracker.get_slot("number")}

    async def extract_room_type(
        self,
        dispatcher: CollectingDispatcher,
        tracker: Tracker,
        domain: DomainDict,
    ) -> Dict[Text, Any]:
        return {"room_type": tracker.get_slot("room_type")}

    async def validate_number(
        self,
        value: Any,
        dispatcher: CollectingDispatcher,
        tracker: Tracker,
        domain: DomainDict,
    ) -> Dict[Text, Any]:
        return {"number": value}

    async def validate_room_type(
        self,
        value: Any,
        dispatcher: CollectingDispatcher,
        tracker: Tracker,
        domain: DomainDict,
    ) -> Dict[Text, Any]:
        return {"room_type": value}

    async def submit(
        self,
        dispatcher: CollectingDispatcher,
        tracker: Tracker,
        domain: DomainDict,
    ) -> List[Dict]:
        dispatcher.utter_message(
            template="utter_submit",
            number=tracker.get_slot("number"),
            room_type=tracker.get_slot("room_type")
        )
        return []


class ValidateBookRoomNumberInfo(FormValidationAction):
    def name(self) -> Text:
        return "validate_form_book_room_number"

    async def required_slots(
        self,
        domain_slots: List[Text],
        dispatcher: CollectingDispatcher,
        tracker: Tracker,
        domain: DomainDict,
    ) -> List[Text]:
        return ["room_type"]

    async def extract_room_type(
        self,
        dispatcher: CollectingDispatcher,
        tracker: Tracker,
        domain: DomainDict,
    ) -> Dict[Text, Any]:
        return {"room_type": tracker.get_slot("room_type")}

    async def validate_room_type(
        self,
        value: Any,
        dispatcher: CollectingDispatcher,
        tracker: Tracker,
        domain: DomainDict,
    ) -> Dict[Text, Any]:
        return {"room_type": value}

    async def submit(
        self,
        dispatcher: CollectingDispatcher,
        tracker: Tracker,
        domain: DomainDict,
    ) -> List[Dict]:
        dispatcher.utter_message(
            template="utter_submit",
            room_type=tracker.get_slot("room_type")
        )
        return []


class ResetSlots(Action):
    def name(self):
        return "action_reset_slots"

    async def run(self, dispatcher, tracker, domain):
        return [SlotSet("number", None), SlotSet("room_type", None)]


class MyFallbackAction(Action):
    def name(self):
        return "action_my_fallback"

    async def run(self, dispatcher, tracker, domain):
        dispatcher.utter_message(template="utter_fallback_message")
        return [UserUtteranceReverted()]


class ActionCheckInTime(Action):
    def name(self):
        return "action_check_in_time"

    async def run(self, dispatcher, tracker, domain):
        dispatcher.utter_message(template="utter_check_in_time")
        repeat(tracker, dispatcher)
        return [UserUtteranceReverted()]


class ActionCheckOutTime(Action):
    def name(self):
        return "action_check_out_time"

    async def run(self, dispatcher, tracker, domain):
        dispatcher.utter_message(template="utter_check_out_time")
        repeat(tracker, dispatcher)
        return [UserUtteranceReverted()]


class ActionCancelReservation(Action):
    def name(self):
        return "action_cancel_reservation"

    async def run(self, dispatcher, tracker, domain):
        dispatcher.utter_message(template="utter_cancel_reservation")
        repeat(tracker, dispatcher)
        return [UserUtteranceReverted()]


class ActionCancellationPolicy(Action):
    def name(self):
        return "action_cancellation_policy"

    async def run(self, dispatcher, tracker, domain):
        dispatcher.utter_message(template="utter_cancellation_policy")
        repeat(tracker, dispatcher)
        return [UserUtteranceReverted()]


class ActionHaveRestaurant(Action):
    def name(self):
        return "action_have_restaurant"

    async def run(self, dispatcher, tracker, domain):
        dispatcher.utter_message(template="utter_have_restaurant")
        repeat(tracker, dispatcher)
        return [UserUtteranceReverted()]


class ActionBreakfastAvail(Action):
    def name(self):
        return "action_breakfast_avail"

    async def run(self, dispatcher, tracker, domain):
        dispatcher.utter_message(template="utter_breakfast_avail")
        repeat(tracker, dispatcher)
        return [UserUtteranceReverted()]


class ActionBreakfastTime(Action):
    def name(self):
        return "action_breakfast_time"

    async def run(self, dispatcher, tracker, domain):
        dispatcher.utter_message(template="utter_breakfast_time")
        repeat(tracker, dispatcher)
        return [UserUtteranceReverted()]


class ActionRestaurantTime(Action):
    def name(self):
        return "action_restaurant_time"

    async def run(self, dispatcher, tracker, domain):
        dispatcher.utter_message(template="utter_restaurant_time")
        repeat(tracker, dispatcher)
        return [UserUtteranceReverted()]


class ActionShowRoomImage(Action):

    def name(self) -> Text:
        return "action_show_room_image"

    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:

        room_type = tracker.get_slot('room_type')
        
        if room_type == "simple":
            dispatcher.utter_message(text="Here is an image of our simple room.", image="url_to_simple_room_image.jpg")
        elif room_type == "deluxe":
            dispatcher.utter_message(text="Here is an image of our deluxe room.", image="url_to_deluxe_room_image.jpg")
        else:
            dispatcher.utter_message(text="Sorry, I don't have an image for that room type.")
        
        return []